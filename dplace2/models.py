from itertools import groupby
from collections import defaultdict

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
from sqlalchemy.ext.declarative import declared_attr

from clld import interfaces
from clld.db.meta import Base, CustomModelMixin, PolymorphicBaseMixin
from clld.db.models.common import (
    Language, Contribution, Parameter, DomainElement, IdNameDescriptionMixin, Value,
    ValueSet, Combination,
)
from clld.db.models.source import HasSourceNotNullMixin

from clld_phylogeny_plugin.interfaces import IPhylogeny
from clld_phylogeny_plugin.models import Phylogeny

from dplace2.interfaces import ISocietyset


def grouped_values(combination):
    for lpk, values in groupby(
        sorted(combination.values, key=lambda v: v.valueset.language_pk),
        lambda v: v.valueset.language_pk
    ):
        values_, language = defaultdict(list), None
        for v in values:
            if not language:
                language = v.valueset.language
            values_[v.valueset.parameter_pk].append(v)
        assert len(values_) == len(combination.parameters), 'missing value for at least one parameter!'
        yield language, values_


class WithSourceMixin(object):
    year = Column(Integer)
    author = Column(Unicode)
    url = Column(Unicode)
    reference = Column(Unicode)


class VariablePhylogeny(Base):
    __table_args__ = (UniqueConstraint('variable_pk', 'phylogeny_pk'),)
    variable_pk = Column(Integer, ForeignKey('variable.pk'))
    phylogeny_pk = Column(Integer, ForeignKey('phylogeny.pk'))


@implementer(ISocietyset)
class Societyset(Base, PolymorphicBaseMixin, IdNameDescriptionMixin, WithSourceMixin):
    color = Column(Unicode)
    count_societies = Column(Integer)


class DatasetSocietyset(Base):
    __table_args__ = ()
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    societyset_pk = Column(Integer, ForeignKey('societyset.pk'))


@implementer(interfaces.IContribution)
class DplaceDataset(CustomModelMixin, Contribution, WithSourceMixin):
    pk = Column(Integer, ForeignKey('contribution.pk'), primary_key=True)
    reference = Column(Unicode)
    type = Column(Unicode)
    count_societies = Column(Integer)
    count_variables = Column(Integer)
    societysets = relationship(Societyset, secondary=DatasetSocietyset.__table__)


class SocietyRelation(Base):
    from_pk = Column(Integer, ForeignKey('society.pk'))
    to_pk = Column(Integer, ForeignKey('society.pk'))


@implementer(interfaces.ILanguage)
class Society(CustomModelMixin, Language):
    pk = Column(Integer, ForeignKey('language.pk'), primary_key=True)
    xid = Column(Unicode)
    name_in_source = Column(Unicode)
    societyset_pk = Column(Integer, ForeignKey('societyset.pk'))
    societyset = relationship(Societyset, backref='societies')
    region = Column(Unicode)
    glottocode = Column(Unicode)
    language = Column(Unicode)
    language_family = Column(Unicode)
    year = Column(Unicode)
    hraf_name = Column(Unicode)
    hraf_id = Column(Unicode)

    @declared_attr
    def related(cls):
        return relationship(
            cls,
            secondary=SocietyRelation.__table__,
            primaryjoin=cls.pk==SocietyRelation.from_pk,
            secondaryjoin=cls.pk==SocietyRelation.to_pk)

    @property
    def hraf_url(self):
        if self.hraf_id:
            return 'http://ehrafworldcultures.yale.edu/collection?owc={0}'.format(
                self.hraf_id)


class SocietyPhylogeny(Base):
    __table_args__ = (UniqueConstraint('society_pk', 'phylogeny_pk'),)
    label = Column(Unicode)
    society_pk = Column(Integer, ForeignKey('society.pk'))
    phylogeny_pk = Column(Integer, ForeignKey('phylogeny.pk'))
    society = relationship(Society, backref='phylogeny_assocs')
    phylogeny = relationship(Phylogeny, backref='society_assocs')


class Category(Base, IdNameDescriptionMixin):
    pass


class VariableVariable(Base):
    __table_args__ = ()
    variable_pk = Column(Integer, ForeignKey('variable.pk'))
    comparable_pk = Column(Integer, ForeignKey('variable.pk'))


@implementer(interfaces.IParameter)
class Variable(CustomModelMixin, Parameter):
    pk = Column(Integer, ForeignKey('parameter.pk'), primary_key=True)
    type = Column(Unicode)
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    dataset = relationship(DplaceDataset, backref='variables')
    categories_str = Column(Unicode)
    phylogenies = relationship(Phylogeny, secondary=VariablePhylogeny.__table__)

    @declared_attr
    def comparable_variables(cls):
        return relationship(
            cls,
            secondary=VariableVariable.__table__,
            primaryjoin=cls.pk == VariableVariable.variable_pk,
            secondaryjoin=cls.pk == VariableVariable.comparable_pk,
        )


@implementer(IPhylogeny)
class DplacePhylogeny(CustomModelMixin, Phylogeny, WithSourceMixin):
    pk = Column(Integer, ForeignKey('phylogeny.pk'), primary_key=True)
    glottolog = Column(Boolean)
    variables = relationship(Variable, secondary=VariablePhylogeny.__table__)


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

    def spec(self):
        res = ''
        if self.year:
            res += ' ({0})'.format(self.year)
        if self.sub_case:
            res += ' [{0}]'.format(self.sub_case)
        return res.strip()


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
        elif 'color' in value.jsondatadict:
            icon = 's' + value.jsondata['color'][1:]
    elif isinstance(ctx, Value):
        if ctx.domainelement:
            icon = ctx.domainelement.icon
        elif 'color' in ctx.jsondatadict:
            icon = 's' + ctx.jsondata['color'][1:]
    elif isinstance(ctx, DomainElement):
        icon = ctx.icon
    elif isinstance(ctx, Language):
        icon = 'c' + ctx.societyset.color[1:]
    elif isinstance(ctx, Societyset):
        icon = 'c' + ctx.color[1:]
    return icon
