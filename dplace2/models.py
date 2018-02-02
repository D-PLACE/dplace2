from zope.interface import implementer
from sqlalchemy import (
    Column,
    Unicode,
    Float,
    Integer,
    Boolean,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from clld import interfaces
from clld.db.meta import Base, CustomModelMixin
from clld.db.models.common import (
    Language, Contribution, Parameter, DomainElement, IdNameDescriptionMixin, Value,
    ValueSet,
)
from clld.db.models.source import HasSourceNotNullMixin

from dplace2.interfaces import IPhylogeny


class WithSourceMixin(object):
    year = Column(Integer)
    author = Column(Unicode)
    url = Column(Unicode)
    reference = Column(Unicode)


@implementer(IPhylogeny)
class Phylogeny(Base, IdNameDescriptionMixin, WithSourceMixin):
    newick = Column(Unicode)
    glottolog = Column(Boolean)


class Label(Base, IdNameDescriptionMixin):
    phylogeny_pk = Column(Integer, ForeignKey('phylogeny.pk'))
    phylogeny = relationship(Phylogeny, backref='labels')
    glottocode = Column(Unicode)


@implementer(interfaces.IContribution)
class DplaceDataset(CustomModelMixin, Contribution, WithSourceMixin):
    pk = Column(Integer, ForeignKey('contribution.pk'), primary_key=True)
    type = Column(Unicode)
    count_societies = Column(Integer)
    count_variables = Column(Integer)
    color = Column(Unicode)


@implementer(interfaces.ILanguage)
class Society(CustomModelMixin, Language):
    pk = Column(Integer, ForeignKey('language.pk'), primary_key=True)
    xid = Column(Unicode)
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    dataset = relationship(DplaceDataset)
    region = Column(Unicode)
    glottocode = Column(Unicode)
    language = Column(Unicode)
    language_family = Column(Unicode)


class SocietyLabel(Base):
    __table_args__ = (UniqueConstraint('society_pk', 'label_pk'),)

    society_pk = Column(Integer, ForeignKey('society.pk'), nullable=False)
    society = relationship(Society)
    label_pk = Column(Integer, ForeignKey('label.pk'), nullable=False)
    label = relationship(Label, backref='society_assocs')
    ord = Column(Integer, default=1)


class Category(Base, IdNameDescriptionMixin):
    pass


@implementer(interfaces.IParameter)
class Variable(CustomModelMixin, Parameter):
    pk = Column(Integer, ForeignKey('parameter.pk'), primary_key=True)
    type = Column(Unicode)
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    dataset = relationship(DplaceDataset, backref='variables')
    categories_str = Column(Unicode)


class VariableCategory(Base):
    __table_args__ = ()
    variable_pk = Column(Integer, ForeignKey('variable.pk'))
    category_pk = Column(Integer, ForeignKey('category.pk'))
    variable = relationship(Variable, backref='category_assocs')
    category = relationship(Category, backref='variable_assocs')


@implementer(interfaces.IDomainElement)
class Code(CustomModelMixin, DomainElement):
    pk = Column(Integer, ForeignKey('domainelement.pk'), primary_key=True)
    color = Column(Unicode)


@implementer(interfaces.IValue)
class Datapoint(CustomModelMixin, Value):
    pk = Column(Integer, ForeignKey('value.pk'), primary_key=True)
    comment = Column(Unicode)
    year = Column(Integer)
    sub_case = Column(Unicode)
    source = Column(Unicode)
    value_float = Column(Float)


class DatapointReference(Base, HasSourceNotNullMixin):
    __table_args__ = (UniqueConstraint('value_pk', 'source_pk', 'description'),)

    value_pk = Column(Integer, ForeignKey('value.pk'), nullable=False)
    value = relationship(Value, innerjoin=True, backref="references")


def get_color(ctx):
    color = None
    if isinstance(ctx, ValueSet):
        value = ctx.values[0]
        if value.domainelement:
            color = value.domainelement.color
        elif 'color' in value.jsondata or {}:
            color = value.jsondata['color']
    elif isinstance(ctx, Value):
        if ctx.domainelement:
            color = ctx.domainelement.color
        elif 'color' in ctx.jsondata or {}:
            color = ctx.jsondata['color']
    elif isinstance(ctx, DomainElement):
        color = ctx.color
    elif isinstance(ctx, Language):
        color = ctx.dataset.color
    elif isinstance(ctx, Contribution):
        color = ctx.color
    return color
