import streamlit as st
from ultralytics import YOLO
from PIL import Image
import cv2

@st.cache_resource
def load_model():
    return YOLO("./models/best.pt")

model = load_model()

st.title("กล้องตรวจจับขยะ Real-time 📷")

img_file = st.camera_input("ถ่ายภาพเพื่อวิเคราะห์")

if img_file is not None:
    # แปลงไฟล์ภาพเป็น format ที่ model เข้าใจ
    image = Image.open(img_file)
    results = model(image)
    res_plotted = results[0].plot()
    
    colour = cv2.cvtColor(res_plotted, cv2.COLOR_BGR2RGB)
    st.image(colour , caption='ผลลัพธ์การตรวจจับ')