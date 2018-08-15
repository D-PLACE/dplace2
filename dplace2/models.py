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

from clld_phylogeny_plugin.interfaces import IPhylogeny
from clld_phylogeny_plugin.models import Phylogeny


class WithSourceMixin(object):
    year = Column(Integer)
    author = Column(Unicode)
    url = Column(Unicode)
    reference = Column(Unicode)


@implementer(IPhylogeny)
class DplacePhylogeny(CustomModelMixin, Phylogeny, WithSourceMixin):
    pk = Column(Integer, ForeignKey('phylogeny.pk'), primary_key=True)
    glottolog = Column(Boolean)

    @property
    def citation(self):
        from clld.web.util.htmllib import HTML
        return HTML.blockquote(self.reference)


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
    name_in_source = Column(Unicode)
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    dataset = relationship(DplaceDataset)
    region = Column(Unicode)
    glottocode = Column(Unicode)
    language = Column(Unicode)
    language_family = Column(Unicode)
    year = Column(Unicode)
    hraf_name = Column(Unicode)
    hraf_id = Column(Unicode)

    @property
    def hraf_url(self):
        if self.hraf_id:
            return 'http://ehrafworldcultures.yale.edu/collection?owc={0}'.format(
                self.hraf_id)


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
    icon = Column(Unicode)


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


def get_icon(ctx):
    icon = None
    if isinstance(ctx, ValueSet):
        value = ctx.values[0]
        if value.domainelement:
            icon = value.domainelement.icon
        elif 'color' in value.jsondata or {}:
            icon = 'c' + value.jsondata['color'][1:]
    elif isinstance(ctx, Value):
        if ctx.domainelement:
            icon = ctx.domainelement.icon
        elif 'color' in ctx.jsondata or {}:
            icon = 'c' + ctx.jsondata['color'][1:]
    elif isinstance(ctx, DomainElement):
        icon = ctx.icon
    elif isinstance(ctx, Language):
        icon = 'c' + ctx.dataset.color[1:]
    elif isinstance(ctx, Contribution):
        icon = 'c' + ctx.color[1:]
    return icon
