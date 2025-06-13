from locust import HttpUser, task, between
import random
import string

def random_string(length=10):
    """Genera una cadena aleatoria de letras y dígitos."""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def random_email():
    """Genera un correo electrónico aleatorio."""
    return f"{random_string(8)}@example.com"

class EcommerceUser(HttpUser):
    """
    Clase que representa un usuario virtual para las pruebas de rendimiento del e-commerce.
    """
    host = "http://4.156.84.45"
    wait_time = between(1, 3)  # Espera entre 1 y 3 segundos entre tareas

    @task(2) # Esta tarea se ejecutará el doble de veces que las otras
    def create_user(self):
        """
        Tarea para simular la creación de un nuevo usuario.
        """
        payload = {
            "firstName": random_string(8),
            "lastName": random_string(8),
            "imageUrl": f"https://picsum.photos/200?random={random.randint(1, 1000)}",
            "email": random_email(),
            "phone": f"+1{random.randint(1000000000, 9999999999)}",
            "credential": {
                "username": f"user_{random_string(5)}",
                "password": "securePassword123",
                "roleBasedAuthority": "ROLE_USER",
                "isEnabled": True,
                "isAccountNonExpired": True,
                "isAccountNonLocked": True,
                "isCredentialsNonExpired": True
            }
        }

        with self.client.post("/user-service/api/users", json=payload, catch_response=True) as response:
            if response.status_code == 201 or response.status_code == 200:
                response.success()
            else:
                response.failure(f"Fallo al crear usuario: {response.status_code} - {response.text}")

    @task
    def get_products(self):
        """
        Tarea para simular la obtención de la lista de productos.
        """
        with self.client.get("/product-service/api/products", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Fallo al obtener productos: {response.status_code}")
                
    @task
    def get_all_users(self):
        """
        Tarea para simular la obtención de la lista de todos los usuarios.
        """
        with self.client.get("/user-service/api/users", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Fallo al obtener todos los usuarios: {response.status_code}")

    @task
    def get_user_by_id(self):
        """
        Tarea para obtener un usuario específico por su ID.
        """
        user_id = random.randint(1, 4)  # Asumiendo que los usuarios con ID 1-4 existen
        with self.client.get(f"/user-service/api/users/{user_id}", catch_response=True) as response:
            if response.status_code == 200:
                response.success()
            else:
                response.failure(f"Fallo al obtener el usuario {user_id}: {response.status_code}")
