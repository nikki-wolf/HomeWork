import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify
import datetime as dt
from datetime import datetime

#################################################
# Database Setup
#################################################

engine = create_engine("sqlite:///hawaii.sqlite",connect_args={'check_same_thread': False})
# reflect the database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Station = Base.classes.station
Measurement = Base.classes.measurement

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Flask Routes
#################################################
@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/precipitation<br/>"
        f"/api/stations<br/>"
        f"/api/temperature<br/>"
        f"/api/start<br/>"
        f"/api/start/end<br/>"    
    )


##
## Convert the query results to a Dictionary using 
##        date as the key and prcp as the value.
## Return the JSON representation of your dictionary.
##
@app.route("/api/precipitation")
def precipitaiton():
    ld = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
    ldm1y = datetime.strptime(ld[0], '%Y-%m-%d')- dt.timedelta(days=365)
    lsyrpricip = engine.execute("SELECT date, prcp FROM measurement WHERE prcp IS NOT NULL AND date BETWEEN :ldm1y AND \
                             :ld ORDER BY date DESC", {'ld':ld[0], 'ldm1y': ldm1y}).fetchall()
    dp = []
    for d,p in lsyrpricip:
        dp_dict = {}
        dp_dict["date"] = d
        dp_dict["precipitation"] = p
        dp.append(dp_dict)

    return jsonify(dp)

## Return a JSON list of stations from the dataset.
@app.route("/api/stations")
def stations():
    st1 = session.query(Measurement.station).distinct().all()
    stat1 = [x[0] for x in st1]
    st2 = session.query(Station.station).distinct().all()
    stat2 = [x[0] for x in st2]
    st1st2=list(set(stat1 + stat2))
    jsonstr = f'List of the {len(st1st2)} available stations'
    return jsonify({jsonstr:st1st2})

## query for the dates and temperature observations from a year from the last data point.
## Return a JSON list of Temperature Observations (tobs) for the previous year.
@app.route("/api/temperature")
def temperature():
    ld = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
    ldobj= datetime.strptime(ld[0], '%Y-%m-%d')
    ldm1y2 = ldobj - dt.timedelta(days=365)
    lsyrtemp = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= ldm1y2).all()
    dtobs = []
    for da,temp in lsyrtemp:
        dt_dict = {}
        dt_dict["date"] = da
        dt_dict["temperature"] = temp
        dtobs.append(dt_dict)
    jsonstr= f'Requested temperature observations for the perivious year ({ldm1y2.strftime("%m/%d/%Y")} to {ldobj.strftime("%m/%d/%Y")}) is'
    return jsonify({jsonstr: dtobs})


## Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.
## When given the start only, calculate TMIN, TAVG, and TMAX for all dates greater than and equal to the start date.
## Hint: You may want to look into how to create a defualt value for your route variable.
## When given the start and the end date, calculate the TMIN, TAVG, and TMAX for dates between the start and end date inclusive.

@app.route("/api/", defaults={'start': '08-23-2016'})
@app.route("/api/<start>")
def start_date(start):
    #change the date format from month-day-yr to yr-month-date for start date
    ch='-'
    stch=start.split('-')
    stdtconv=ch.join([stch[2],stch[0],stch[1]])
    stdt= datetime.strptime(stdtconv, '%Y-%m-%d')
    #query from the database
    travg = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= stdt).all()
    # make a numpy list
    travgls = list(np.ravel(travg))
    #return jsonify with added sting
    jsonstr = f"Minimum, Avg., and Maximum temperature for the starting date ({start})"
    return jsonify({jsonstr: travgls})


@app.route("/api/<start>/", defaults={'end':'08-23-2017'})
@app.route("/api/<start>/<end>")
def start_end_date(start,end):
    from sqlalchemy import and_
    #change the date format from month-day-yr to yr-month-date for start and end dates
    ch='-'
    stch=start.split('-')
    stdtconv=ch.join([stch[2],stch[0],stch[1]])
    stdt= datetime.strptime(stdtconv, '%Y-%m-%d')

    ench=end.split('-')
    endtconv=ch.join([ench[2],ench[0],ench[1]])
    endt= datetime.strptime(endtconv, '%Y-%m-%d')

    #query from the database
    travg = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(and_(Measurement.date >= stdt, Measurement.date <= endt)).all()
    # make a numpy list
    travgls = list(np.ravel(travg))
    #return jsonify with added sting
    jsonstr = f"Minimum, Avg., and Maximum temperature for the period({start} to {end})"
    return jsonify({jsonstr: travgls})

if __name__ == '__main__':
    app.run(debug=True)