from locust import HttpUser, task, between
import json
import uuid

class QuickstartUser(HttpUser):
    wait_time = between(5, 9)

    @task(1)
    def mykad(self):
        f = open("car.txt", "r")
        base64 = f.read()
        
        headers = {'content-type': 'application/json'}
        """
        payload = {
            "user": "postman",
            "data": {"instances": [{"input": {"b64": base64}}]}
        }
        """
        #print (payload)
        self.client.post('/default/ds-test', 
                            headers=headers, 
                            data=json.dumps(payload),
                            name='Part Detector Stress Test', 
                            verify=False)


#class WebsiteUser(HttpUser):
#    task_set = UserBehavior
#    min_wait = 5000
#    max_wait = 15000
