import http.client
import urllib.parse

url = urllib.parse.urlparse(url = "https://curl.se/ca/cacert.pem")

connection = http.client.HTTPSConnection(
	host = url.netloc,
	port = url.port
)

print(f"Fetching data from {url.geturl()}...")

connection.request(
	method = "GET",
	url = url.path
)
response = connection.getresponse()
content = response.read()

connection.close()

with open(file = "./cacert.pem", mode = "wb") as file:
    file.write(content)
