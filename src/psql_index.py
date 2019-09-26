import dotenv
from configparser import ConfigParser
import sqlalchemy as db
from sqlalchemy.engine.reflection import Inspector

config = ConfigParser()
config.read(dotenv.find_dotenv("server.ini"))

engine = db.create_engine(config["dummy_db"]["url"])
insp = Inspector.from_engine(engine)

print(insp.get_indexes("child_table", schema="test"))

print(config["dummy_db"]["url"])



