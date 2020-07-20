import os
import requests
import base64

def benchmark_process():
    root_path = 'C:/Users/gideonmanurung/Documents/Work/Qoala/vehicle-playground-app/test_image'
    list_image = []
    list_image = os.listdir(root_path)
    payload_request_detector = {}
    payload_request_analyzer = {}

    for image in list_image:
        with open(str(root_path+'/'+image), "rb") as img_file:
            img_b64 = base64.b64encode(img_file.read())
        
        payload_request_detector['image'] = img_b64
        payload_request_detector['user_id'] = "test"
        payload_request_detector['file_name'] = "test.jpg"

        req_detector = requests.post(url = "https://vehicle-playground-app-dot-qoala-217505.appspot.com/detect_car_part", data = payload_request_detector)
        print(payload_request_detector)

        data_detector = req_detector.json()
        print(data_detector)

        job_id = data_detector['data']['job_id']
        
        for image_crop in data_detector['data']['list_cropped_image']:
            payload_request_analyzer['part_name'] = image_crop['part_name']
            payload_request_analyzer['image_url'] = image_crop['image_url']
            payload_request_analyzer['image_id'] = image_crop['image_id']
            payload_request_analyzer['job_id'] = job_id
            req_analyzer = requests.post(url = "https://vehicle-playground-app-dot-qoala-217505.appspot.com/analyze_part", data = payload_request_analyzer)
    

if __name__ == "__main__":
    benchmark_process()