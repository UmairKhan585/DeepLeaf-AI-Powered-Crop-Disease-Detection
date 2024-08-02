from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware   
import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
import tensorflow as tf
from typing import List

app = FastAPI()

origins = [
    "http://localhost",
    "http://localhost:3000",
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL = tf.keras.models.load_model("E:/FYP ALL DATA/Rice Disease website/saved_model/My_Aug-Efficient-B1.h5")

# Define class names
CLASS_NAMES = ['Rice_BrownSpot', 'Rice_Healthy', 'Rice_LeafBlast', 'Rice_NeckBlast']

@app.get("/ping")
async def ping():
    return "Hello, I am alive"

def read_file_as_image(data) -> np.ndarray:
    image = np.array(Image.open(BytesIO(data)))
    return image

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    image = read_file_as_image(await file.read())

    # Resize the image to match the model input shape
    resized_image = tf.image.resize(image, [224, 224])

    # Normalize image
    resized_image = resized_image / 255.0  # Assuming model expects input in range [0, 1]

    # Add batch dimension
    img_batch = np.expand_dims(resized_image, axis=0)

    # Make prediction
    predictions = MODEL.predict(img_batch)

    # Get predicted class and confidence
    predicted_class = CLASS_NAMES[np.argmax(predictions[0])]
    confidence = np.max(predictions[0])

    return {
        'class': predicted_class,
        'confidence': float(confidence)
    }


if __name__ == "__main__":
    uvicorn.run(app, host='localhost', port=8000)
