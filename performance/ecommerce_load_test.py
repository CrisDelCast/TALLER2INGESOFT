from locust import HttpUser, task, between
import json
import random

BASE_PRODUCT_IDS = list(range(1, 200))  # IDs válidos aproximados
BASE_USER_IDS = list(range(1, 100))

class EcommerceUser(HttpUser):
    """Simula un usuario navegando por el e-commerce sin autenticación"""

    wait_time = between(1, 3)

    @task(5)
    def list_products(self):
        self.client.get("/product-service/api/products", name="list_products")

    @task(3)
    def view_product_detail(self):
        product_id = random.choice(BASE_PRODUCT_IDS)
        self.client.get(f"/product-service/api/products/{product_id}", name="product_detail")
    
    @task(1)
    def view_random_user(self):
        user_id = random.choice(BASE_USER_IDS)
        self.client.get(f"/user-service/api/users/{user_id}", name="user_detail")

class LightLoadUser(EcommerceUser):
    wait_time = between(2, 5)
    weight = 1

class HeavyLoadUser(EcommerceUser):
    wait_time = between(0.5, 2)
    weight = 4

class ProductServiceUser(HttpUser):
    """Usuario especializado para pruebas del servicio de productos"""
    wait_time = between(1, 3)
    
    @task(6)
    def browse_products(self):
        """Navegar productos intensivamente"""
        # Lista de productos con paginación y ordenamiento
        page = random.randint(1, 20)
        size = random.choice([10, 20, 50, 100])
        sort_by = random.choice(["price", "name", "rating", "date"])
        order = random.choice(["asc", "desc"])
        self.client.get(
            f"/product-service/api/products?page={page}&size={size}&sort={sort_by}&order={order}",
            name="products_advanced_paginated"
        )
        
        # Productos por categoría
        categories = ["electronics", "clothing", "books", "home", "sports"]
        category = random.choice(categories)
        self.client.get(f"/product-service/api/products/category/{category}", name="products_by_category")
        
        # Productos en oferta
        self.client.get("/product-service/api/products/featured", name="featured_products")
        self.client.get("/product-service/api/products/on-sale", name="sale_products")
    
    @task(3)
    def search_products(self):
        """Búsquedas intensivas de productos"""
        search_terms = [
            "laptop", "smartphone", "camera", "headphones", "tablet",
            "book", "shoes", "shirt", "jacket", "watch", "bag"
        ]
        
        term = random.choice(search_terms)
        
        # Búsqueda simple
        self.client.get(f"/product-service/api/products/search?q={term}", name="simple_search")
        
        # Búsqueda con filtros
        min_price = random.randint(10, 100)
        max_price = min_price + random.randint(50, 500)
        self.client.get(
            f"/product-service/api/products/search?q={term}&minPrice={min_price}&maxPrice={max_price}",
            name="filtered_search"
        )
    
    @task(2)
    def product_details(self):
        """Ver detalles de productos específicos"""
        product_id = random.randint(1, 1000)
        
        # Detalles del producto
        self.client.get(f"/product-service/api/products/{product_id}", name="product_details")
        
        # Reviews del producto
        self.client.get(f"/product-service/api/products/{product_id}/reviews", name="product_reviews")
        
        # Productos relacionados
        self.client.get(f"/product-service/api/products/{product_id}/related", name="related_products")

class OrderServiceUser(HttpUser):
    """Usuario especializado para pruebas del servicio de órdenes"""
    wait_time = between(1, 4)
    
    def on_start(self):
        self.auth_token = "test_token_" + str(random.randint(1000, 9999))
        self.user_id = random.randint(1, 1000)
    
    @task(3)
    def order_operations(self):
        """Operaciones de órdenes"""
        headers = {"Authorization": f"Bearer {self.auth_token}"}
        
        # Crear orden compleja
        order_data = {
            "userId": self.user_id,
            "items": [
                {
                    "productId": random.randint(1, 100),
                    "quantity": random.randint(1, 3),
                    "price": round(random.uniform(10.0, 200.0), 2)
                }
                for _ in range(random.randint(1, 5))
            ],
            "shippingAddress": {
                "street": f"{random.randint(100, 9999)} Test Ave",
                "city": random.choice(["New York", "Los Angeles", "Chicago", "Houston"]),
                "zipCode": f"{random.randint(10000, 99999)}",
                "country": "USA"
            },
            "paymentMethod": random.choice(["credit_card", "debit_card", "paypal"])
        }
        
        response = self.client.post("/order-service/api/orders", json=order_data, headers=headers, name="create_complex_order")
        
        if response.status_code == 201:
            order_id = response.json().get("orderId", random.randint(1, 1000))
            
            # Operaciones sobre la orden
            self.client.get(f"/order-service/api/orders/{order_id}", headers=headers, name="get_order")
            self.client.get(f"/order-service/api/orders/{order_id}/status", headers=headers, name="order_status_check")
            
            # Actualizar orden (si está permitido)
            update_data = {"status": "processing"}
            self.client.put(f"/order-service/api/orders/{order_id}/status", json=update_data, headers=headers, name="update_order_status")
    
    @task(2)
    def order_queries(self):
        """Consultas de órdenes"""
        headers = {"Authorization": f"Bearer {self.auth_token}"}
        
        # Mis órdenes con filtros
        status = random.choice(["pending", "processing", "shipped", "delivered"])
        self.client.get(f"/order-service/api/orders/my-orders?status={status}", headers=headers, name="orders_by_status")
        
        # Órdenes por fecha
        days_ago = random.randint(1, 30)
        self.client.get(f"/order-service/api/orders/my-orders?days={days_ago}", headers=headers, name="orders_by_date")
        
        # Estadísticas de órdenes
        self.client.get("/order-service/api/orders/stats", headers=headers, name="order_statistics")

class PaymentServiceUser(HttpUser):
    """Usuario especializado para pruebas del servicio de pagos"""
    wait_time = between(2, 5)
    
    def on_start(self):
        self.auth_token = "payment_token_" + str(random.randint(1000, 9999))
    
    @task(4)
    def payment_processing(self):
        """Procesar pagos diversos"""
        headers = {"Authorization": f"Bearer {self.auth_token}"}
        
        payment_methods = ["credit_card", "debit_card", "paypal", "apple_pay", "google_pay"]
        
        payment_data = {
            "orderId": random.randint(1, 1000),
            "amount": round(random.uniform(5.0, 1000.0), 2),
            "currency": "USD",
            "paymentMethod": random.choice(payment_methods),
            "cardToken": f"tok_test_{random.randint(10000, 99999)}",
            "billingAddress": {
                "street": f"{random.randint(100, 9999)} Payment St",
                "city": "Payment City",
                "zipCode": f"{random.randint(10000, 99999)}",
                "country": "USA"
            }
        }
        
        # Procesar pago
        response = self.client.post("/payment-service/api/payments", json=payment_data, headers=headers, name="process_payment")
        
        if response.status_code == 200:
            payment_id = response.json().get("paymentId", random.randint(1, 1000))
            
            # Verificar estado del pago
            self.client.get(f"/payment-service/api/payments/{payment_id}", headers=headers, name="payment_status")
            
            # Historial de pagos
            self.client.get("/payment-service/api/payments/history", headers=headers, name="payment_history")
    
    @task(1)
    def payment_validation(self):
        """Validar información de pago"""
        headers = {"Authorization": f"Bearer {self.auth_token}"}
        
        # Validar tarjeta
        card_data = {
            "cardNumber": "4111111111111111",
            "expiryMonth": random.randint(1, 12),
            "expiryYear": random.randint(2024, 2030),
            "cvv": f"{random.randint(100, 999)}"
        }
        self.client.post("/payment-service/api/payments/validate-card", json=card_data, headers=headers, name="validate_card")
        
        # Verificar límites
        amount_data = {"amount": random.uniform(100.0, 5000.0), "currency": "USD"}
        self.client.post("/payment-service/api/payments/check-limits", json=amount_data, headers=headers, name="check_payment_limits")

class HealthCheckUser(HttpUser):
    """Usuario para monitorear health checks de todos los servicios"""
    wait_time = between(5, 10)
    
    @task(1)
    def check_all_services(self):
        """Verificar salud de todos los microservicios"""
        services = [
            "user-service",
            "product-service",
            "order-service",
            "payment-service",
            "shipping-service"
        ]
        
        for service_name in services:
            # Health check endpoint
            self.client.get(f"/{service_name}/actuator/health", name=f"{service_name}_health")
            
            # Metrics endpoint
            self.client.get(f"/{service_name}/actuator/metrics", name=f"{service_name}_metrics")
            
            # Info endpoint
            self.client.get(f"/{service_name}/actuator/info", name=f"{service_name}_info")

# Nuevo escenario de prueba
class MobileAppUser(HttpUser):
    """Usuario simulando comportamiento de aplicación móvil"""
    wait_time = between(0.5, 2)
    
    def on_start(self):
        self.auth_token = "mobile_token_" + str(random.randint(1000, 9999))
    
    @task(3)
    def mobile_operations(self):
        """Operaciones típicas de app móvil"""
        headers = {
            "Authorization": f"Bearer {self.auth_token}",
            "User-Agent": "MobileApp/1.0"
        }
        
        # Búsqueda rápida
        self.client.get("/product-service/api/products/quick-search?q=phone", headers=headers, name="mobile_quick_search")
        
        # Ver ofertas flash
        self.client.get("/product-service/api/products/flash-deals", headers=headers, name="mobile_flash_deals")
        
        # # Notificaciones push (Asumiendo que existe un 'notification-service')
        # self.client.post("/notification-service/api/notifications/register", 
        #                 json={"deviceToken": f"token_{random.randint(1000, 9999)}"},
        #                 headers=headers,
        #                 name="mobile_push_register")

# Configuración actualizada de escenarios de prueba
def create_load_test_config():
    """Retorna configuración para diferentes escenarios de prueba"""
    return {
        "light_load": {
            "users": 100,
            "spawn_rate": 10,
            "run_time": "10m",
            "user_classes": [LightLoadUser, MobileAppUser, HealthCheckUser]
        },
        "normal_load": {
            "users": 200,
            "spawn_rate": 20,
            "run_time": "15m",
            "user_classes": [EcommerceUser, ProductServiceUser, OrderServiceUser, MobileAppUser]
        },
        "heavy_load": {
            "users": 400,
            "spawn_rate": 40,
            "run_time": "20m",
            "user_classes": [HeavyLoadUser, ProductServiceUser, OrderServiceUser, PaymentServiceUser, MobileAppUser]
        },
        "spike_test": {
            "users": 1000,
            "spawn_rate": 100,
            "run_time": "10m",
            "user_classes": [EcommerceUser, MobileAppUser]
        },
        "endurance_test": {
            "users": 300,
            "spawn_rate": 30,
            "run_time": "120m",
            "user_classes": [EcommerceUser, ProductServiceUser, OrderServiceUser, PaymentServiceUser, HealthCheckUser, MobileAppUser]
        }
    }

if __name__ == "__main__":
    # Ejemplo de uso:
    # locust -f ecommerce_load_test.py --headless -u 100 -r 10 --run-time 300s --host http://localhost:9081
    print("Ecommerce Load Test Suite")
    print("Available user classes:")
    print("- EcommerceUser: General e-commerce operations")
    print("- ProductServiceUser: Product browsing and search")
    print("- OrderServiceUser: Order management operations")
    print("- PaymentServiceUser: Payment processing")
    print("- HealthCheckUser: Service health monitoring")
    print("\nExample usage:")
    print("locust -f ecommerce_load_test.py --headless -u 100 -r 10 --run-time 300s --host http://product-service:8081") 