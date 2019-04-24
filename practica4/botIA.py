#!/usr/bin/env python3

################################################################################
## En este documento estan implementadas las funciones de gestion de usuarios
################################################################################
## Author: Santiago Valderrabano y Martin de las Heras
## Email: santiago.valderrabano@estudiante.uam.es
##        martin.delasheras@estudiante.uam.es
################################################################################

import requests
import os

url = "http://150.244.56.96/intart/myupload.php" #myupload.php


def send_post_client(url, args):
    try:
        request = requests.post(url, files = args)
    except requests.ConnectionError:
        print("[ERROR]")
        return "Connection error"
    except requests.exceptions.Timeout:
        print("[ERROR]")
        return "Timeout error"
    except requests.exceptions.TooManyRedirects:
        print("[ERROR]")
        return "Too Many Redirects Error"
    except requests.exceptions.RequestException:
        print("[ERROR]")
        return "Request Exception"


    return request.text


def subir_bot(group, pair, code, uploaded_file):
    print("--> Subiendo archivo: ", group, " | ", pair, " | ", code, " | ", uploaded_file, " .......")

    if os.path.exists(uploaded_file):
        try:
            file = open(uploaded_file, 'rb')
        except EnvironmentError:
            print("[ERROR]")
            print("Error al abrir el archivo")
            return None
    else:
        print("[ERROR]")
        print("--> El archivo no existe")
        return None

    arguments = {'group': group, 'pair': pair, 'code': code, 'uploaded_file': file}

    return send_post_client(url, arguments)


# respuesta = subir_bot("2302", "P03", "ab29a", "/Users/santi/UAM/3º/Segundo Cuatrimestre/IA/practicas-ia/practica4/2302_P03_ab29a.cl")
# respuesta = subir_bot("2302", "P03", "a2b3d", "/Users/santi/UAM/3º/Segundo Cuatrimestre/IA/practicas-ia/practica4/2302_P03_a2b3d.cl")
# respuesta = subir_bot("2302", "P03", "fc259", "/Users/santi/UAM/3º/Segundo Cuatrimestre/IA/practicas-ia/practica4/2302_P03_fc259.cl")
print(respuesta)
