from fastapi import FastAPI, HTTPException
import databases
import sqlalchemy
from os import getenv

# Database URL from environment variable or default
DATABASE_URL = getenv("DATABASE_URL", "postgresql://user:password@db:5432/mydatabase")

database = databases.Database(DATABASE_URL)
metadata = sqlalchemy.MetaData()

# Define table schema
notes = sqlalchemy.Table(
    "notes",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("text", sqlalchemy.String),
)

# Connect to database
engine = sqlalchemy.create_engine(DATABASE_URL)
metadata.create_all(engine)

app = FastAPI()

@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

@app.get("/")
async def read_note():
    query = notes.select().limit(1)  # Ensure the query tries to fetch at least one record
    result = await database.fetch_one(query)
    if result is None:
        # If no record is found, return a placeholder or throw an error
        raise HTTPException(status_code=404, detail="No notes found")
    return {"server_id": getenv("SERVER_ID", "1"), "note": result["text"]}