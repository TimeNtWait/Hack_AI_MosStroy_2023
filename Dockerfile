FROM python:3.8.16-slim as build

RUN apt update && apt --no-install-recommends --assume-yes install \
    g++ python3-dev curl git


WORKDIR /app

# Create the virtual environment.
RUN python3.8 -m venv /venv
ENV PATH=/venv/bin:$PATH
RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install gdown

# NOTE - We have to do requirements as default build install only pyproject.toml dependencies
RUN pip3 install lightautoml
RUN pip3 install streamlit
RUN pip3 install openpyxl
RUN #pip3 install --no-cache-dir poetry~=1.5
RUN #poetry export --without-hashes > requirements.txt
RUN #pip3 install --no-cache-dir -r requirements.txt

RUN mkdir ./test4/
RUN mkdir ./demo/
RUN gdown https://drive.google.com/uc?id=1G7QbMamB-ZM-W8gfcb3wBCxzvqa4oC8- -O ./demo/regressor.pkl
RUN gdown https://drive.google.com/uc?id=1dsINlp0atln_E1EpJ81wLF7fLxEHf3EV -O ./demo/classifier.pkl
RUN #gdown https://drive.google.com/uc?id=19gHM6fmlVO_eie-YXhV39An2wk2RQsIT -O ./demo/historical_data.csv


COPY demo ./demo/
COPY README.md ./





CMD ["streamlit", "run", "demo/streamlit_demo.py", "--server.port", "5000", "--server.maxUploadSize", "500", "--theme.base", "light"]