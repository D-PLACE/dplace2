from zope.interface import implementer
from sqlalchemy import (
    Column,
    Unicode,
    Float,
    Integer,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from clld import interfaces
from clld.db.meta import Base, CustomModelMixin
from clld.db.models.common import (
    Language, Contribution, Parameter, DomainElement, IdNameDescriptionMixin, Value,
)
from clld.db.models.source import HasSourceNotNullMixin


@implementer(interfaces.IContribution)
class DplaceDataset(CustomModelMixin, Contribution):
    pk = Column(Integer, ForeignKey('contribution.pk'), primary_key=True)
    type = Column(Unicode)
    count_societies = Column(Integer)
    count_variables = Column(Integer)
    color = Column(Unicode)


@implementer(interfaces.ILanguage)
class Society(CustomModelMixin, Language):
    pk = Column(Integer, ForeignKey('language.pk'), primary_key=True)
    dataset_pk = Column(Integer, ForeignKey('dplacedataset.pk'))
    dataset = relationship(DplaceDataset)
    region = Column(Unicode)


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


#class Tree(Base, IdNameDescriptionMixin):
#    pass


#class TreeLabel(Base, IdNameDescriptionMixin):
#    tree_pk = Column()
#    tree = relationship()


#class TreeLabelSociety():
#    ord = Column(Integer)
