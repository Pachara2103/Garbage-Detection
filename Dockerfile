FROM python:3.10-slim

WORKDIR /app

# ต้องลง Library กราฟิกก่อน ไม่งั้น OpenCV พัง
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# 2. แนะนำ: ลง PyTorch แบบ CPU (ไฟล์เล็ก 200MB) เพื่อประหยัดพื้นที่และเวลา
# ถ้าคุณใช้ Production แบบมี GPU ให้ลบบรรทัดนี้ทิ้งได้เลย
RUN pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Docker Cache run lib ก่อน
COPY requirements.txt .
#  same COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Docker Cache ของไม่ค่อยเปลี่ยนอยู่บนๆ
COPY ./models ./models

COPY . .

# รัน Server
CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]
# 1. CMD [...] เปิดกล่อง (Container) นี้ขึ้นมา ให้รันคำสั่งนี้เป็นอย่างแรกเลยนะ"
# 2. --server.address=0.0.0.0"
# ตัวสำคัญที่สุด: เหมือนเดิมครับ ต้องตั้งเป็น 0.0.0.0 เพื่อให้คนจากข้างนอก (Browser ในคอมเรา) เจาะเข้าไปดูหน้าเว็บใน Docker ได้ ถ้าไม่ใส่ บรรทัดนี้คุณจะเปิดเว็บไม่ขึ้นครับ





