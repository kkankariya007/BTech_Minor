from fastapi import FastAPI, Form, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
from fastapi.responses import StreamingResponse
import io
from io import BytesIO
from keras.models import load_model
import os
import PIL.Image
from PIL import Image, ImageOps #Install pillow instead of PIL
import numpy as np
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'

app = FastAPI()

origins = [
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/upload")
async def receiveFile(file: bytes = File(...)):
    image=Image.open(io.BytesIO(file))
    if not hasattr(PIL.Image, 'Resampling'):
        PIL.Image.Resampling = PIL.Image
    np.set_printoptions(suppress=True)

    model = load_model('converted_keras\keras_model.h5', compile=False)

    class_names = open('converted_keras\labels.txt', 'r').readlines()

    data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)


    size = (224, 224)
    image = ImageOps.fit(image, size, Image.Resampling.LANCZOS)

    image_array = np.asarray(image)

    normalized_image_array = (image_array.astype(np.float32) / 127.0) - 1

    data[0] = normalized_image_array

    prediction = model.predict(data)
    index = np.argmax(prediction)
    class_name = class_names[index]
    print("Class:", class_name[2:])
    return class_name[2:]