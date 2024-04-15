import bcrypt
import uuid
import random

from models import Base, User, Post

BOT_USER_PASSWORD = "secret_botuser_password"


def add_fake_users(session, instance):
    verified_pass = bcrypt.hashpw(str(BOT_USER_PASSWORD).encode('utf-8'),
                                  bcrypt.gensalt())

    v_name = 'meow' + '_' + str(instance)[:8]
    verified = User(username=v_name,
                    name='Neko Cat',
                    password=verified_pass,
                    instance=instance,
                    verified=True)

    verified_posts = ['meow meow meow meow', 'MEOW mEoW MeeOOw']

    for post in verified_posts:
        session.add(Post(posted_by=v_name,
                         content=post,
                         instance=instance))

    session.add(Post(posted_by=v_name,
                     instance=instance,
                     content='meeeeeooooooowwwwwwwww',
                     link='https://www.reddit.com/r/CatFacts/',
                     preview="whoa there, pardner! we're sorry, but you \
                              appear to be a bot and we've seen too many \
                              requests from you lately. we enforce a hard \
                              speed limit on requests that appear to come \
                              from bots to prevent abuse. if you are not a \
                              bot but are spoofing one via your browser's \
                              user agent string:"))

    users = [{'user': 'Melonius Husk',
              'posts': ['I think Neko is deleting fake, scam or maybe even \
                        inactive accounts. My follower count decreased by \
                        ~20k over the past few days.',
                        'I remember when I was a sponge. Simpler times \
                        they were.',
                        'I said dankest not darkest omg']
              },
             {'user': 'Ronald Rump',
              'posts': ['[THIS USER HAS BEEN BANNED FOR VIOLATING NEKO\'S \
                         TERMS AND CONDITIONS]',
                        '[THIS USER HAS BEEN BANNED FOR VIOLATING NEKO\'S \
                         TERMS AND CONDITIONS]',
                        '[THIS USER HAS BEEN BANNED FOR VIOLATING NEKO\'S \
                         TERMS AND CONDITIONS]']}]

    posts = []

    for filler_user in users:
        passwd = bcrypt.hashpw(str(uuid.uuid4()).encode('utf-8'),
                               bcrypt.gensalt())
        u_name = filler_user['user'].replace(' ', '_').lower()
        u_name += '_' + str(instance)[:8]

        name = filler_user['user']
        if name == 'Ronald Rump':
            print('hi')
            name = '(BANNED)'

        session.add(User(username=u_name,
                         name=name,
                         password=passwd,
                         instance=instance))

        for post in filler_user['posts']:
            posts.append(Post(posted_by=u_name,
                              content=post,
                              instance=instance))

    random.shuffle(posts)

    for post in posts:
        session.add(post)

    session.add(verified)
    session.commit()
    return (True, "Fake users created")
