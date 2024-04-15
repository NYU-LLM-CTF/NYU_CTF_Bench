from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, ForeignKey, Integer, String, Boolean

Base = declarative_base()


class User(Base):
    __tablename__ = 'user'
    username = Column(String(100), nullable=False, primary_key=True)
    instance = Column(String(100), nullable=False)
    name = Column(String(100), nullable=False)
    password = Column(String(100), nullable=False)
    verified = Column(Boolean, default=False)


class Post(Base):
    __tablename__ = 'post'
    id = Column(Integer, primary_key=True)
    posted_by = Column(String(100), ForeignKey('user.username'))
    instance = Column(String(100))
    content = Column(String(280))
    preview = Column(String(280))
    link = Column(String(100))
