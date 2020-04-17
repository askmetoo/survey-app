from datetime import datetime

from sqlalchemy import ForeignKey
from sqlalchemy.orm import relationship
from werkzeug.security import generate_password_hash, check_password_hash

from src.python.server import db


class Questions(db.Model):
    __tablename__ = 'questions'
    id = db.Column(db.Integer, primary_key=True)
    hospital_id = db.Column(db.Integer, ForeignKey('Hospitals.id'), nullable=False)
    doctor_id = db.Column(db.Integer, ForeignKey('Doctors.id'), nullable=False)
    question_text = db.Column(db.Text, nullable=False)
    active = db.Column(db.Boolean, default=True, nullable=False)
    free_text = db.Column(db.Boolean, default=False, nullable=False)
    multiple_choice = db.Column(db.Boolean, default=True, nullable=False)
    created_on = db.Column(db.DateTime, default=datetime.now(), nullable=False)


users_hospital_relationship = db.Table('users_hospitals',
                                         db.Column('user_id', db.Integer, ForeignKey('Users.id')),
                                         db.Column('hospital_id', db.Integer, ForeignKey('Hospitals.id'))
                                         )


class Hospital(db.Model):
    __tablename__ = 'hospitals'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    active = db.Column(db.Boolean, default=True, nullable=False)
    created_on = db.Column(db.DateTime, default=datetime.now(), nullable=False)

    users = relationship("User", secondary=users_hospital_relationship, back_populates='hospitals')


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(128), nullable=False, unique=True)
    email = db.Column(db.String(128), nullable=False)
    name = db.Column(db.String(150), nullable=False)
    password_hash = db.Column(db.String(128))
    active = db.Column(db.Boolean, default=True, nullable=False)
    created_on = db.Column(db.DateTime, default=datetime.now(), nullable=False)

    hospitals = relationship("Hospital", secondary=users_hospital_relationship, back_populates='users')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
