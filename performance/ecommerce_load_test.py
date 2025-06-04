from locust import HttpUser, task, between
import json
import random

class EcommerceUser(HttpUser):
    wait_time = between(2, 5)
    
    def on_start(self):
        """Llamado cuando un usuario inicia sesión"""
        self.auth_token = None
        self.user_id = None
        self.login()
    
    def login(self):
        """Simular login de usuario"""
        login_data = {
            "username": f"testuser{random.randint(1, 5000)}",
            "password": "testpass123"
        }
        
        response = self.client.post("/api/users/login", json=login_data)
        if response.status_code == 200:
            self.auth_token = response.json().get("token")
            self.user_id = response.json().get("userId")
    
    @task(4)
    def view_products(self):
        """Simular navegación por productos"""
        # Ver lista de productos con filtros
        category = random.choice(["electronics", "clothing", "books", "home", "sports"])
        self.client.get(f"/api/products?category={category}", name="products_by_category")
        
        # Ver producto específico
        product_id = random.randint(1, 200)
        self.client.get(f"/api/products/{product_id}", name="product_detail")
        
        # Buscar productos con filtros avanzados
        search_terms = ["laptop", "phone", "camera", "book", "clothing", "gaming", "fitness", "kitchen"]
        search_term = random.choice(search_terms)
        min_price = random.randint(10, 100)
        max_price = min_price + random.randint(50, 1000)
        self.client.get(
            f"/api/products/search?q={search_term}&minPrice={min_price}&maxPrice={max_price}",
            name="advanced_product_search"
        )
    
    @task(2)
    def manage_cart(self):
        """Simular manejo del carrito de compras"""
        headers = {"Authorization": f"Bearer {self.auth_token}"} if self.auth_token else {}
        
        # Ver carrito
        self.client.get("/api/cart", headers=headers, name="view_cart")
        
        # Agregar producto al carrito
        cart_item = {
            "productId": random.randint(1, 100),
            "quantity": random.randint(1, 3)
        }
        self.client.post("/api/cart/items", json=cart_item, headers=headers, name="add_to_cart")
        
        # Actualizar cantidad
        item_id = random.randint(1, 10)
        update_data = {"quantity": random.randint(1, 5)}
        self.client.put(f"/api/cart/items/{item_id}", json=update_data, headers=headers, name="update_cart")
    
    @task(1)
    def create_order(self):
        """Simular proceso de creación de orden"""
        headers = {"Authorization": f"Bearer {self.auth_token}"} if self.auth_token else {}
        
        order_data = {
            "items": [
                {
                    "productId": random.randint(1, 100),
                    "quantity": random.randint(1, 2),
                    "price": round(random.uniform(10.0, 500.0), 2)
                }
            ],
            "shippingAddress": {
                "street": "123 Test Street",
                "city": "Test City",
                "zipCode": "12345",
                "country": "Test Country"
            },
            "paymentMethod": "credit_card"
        }
        
        # Crear orden
        response = self.client.post("/api/orders", json=order_data, headers=headers, name="create_order")
        
        if response.status_code == 201:
            order_id = response.json().get("orderId")
            
            # Ver detalles de la orden
            self.client.get(f"/api/orders/{order_id}", headers=headers, name="order_details")
            
            # Simular proceso de pago
            payment_data = {
                "orderId": order_id,
                "amount": order_data["items"][0]["price"],
                "paymentMethod": "credit_card",
                "cardToken": "tok_test_12345"
            }
            self.client.post("/api/payments", json=payment_data, headers=headers, name="process_payment")
    
    @task(1)
    def check_order_status(self):
        """Simular verificación de estado de órdenes"""
        headers = {"Authorization": f"Bearer {self.auth_token}"} if self.auth_token else {}
        
        # Ver mis órdenes
        self.client.get("/api/orders/my-orders", headers=headers, name="my_orders")
        
        # Verificar estado de orden específica
        order_id = random.randint(1, 1000)
        self.client.get(f"/api/orders/{order_id}/status", headers=headers, name="order_status")
        
        # Ver historial de envíos
        self.client.get(f"/api/shipping/orders/{order_id}/tracking", headers=headers, name="shipping_tracking")
    
    @task(1)
    def user_profile_operations(self):
        """Simular operaciones de perfil de usuario"""
        headers = {"Authorization": f"Bearer {self.auth_token}"} if self.auth_token else {}
        
        # Ver perfil
        self.client.get("/api/users/profile", headers=headers, name="user_profile")
        
        # Actualizar perfil
        profile_data = {
            "firstName": f"TestUser{random.randint(1, 1000)}",
            "lastName": "LoadTest",
            "email": f"test{random.randint(1, 1000)}@example.com",
            "phone": f"+1-555-{random.randint(1000, 9999)}"
        }
        self.client.put("/api/users/profile", json=profile_data, headers=headers, name="update_profile")
        
        # Ver historial de órdenes
        self.client.get("/api/users/order-history", headers=headers, name="order_history")

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
            f"/api/products?page={page}&size={size}&sort={sort_by}&order={order}",
            name="products_advanced_paginated"
        )
        
        # Productos por categoría
        categories = ["electronics", "clothing", "books", "home", "sports"]
        category = random.choice(categories)
        self.client.get(f"/api/products/category/{category}", name="products_by_category")
        
        # Productos en oferta
        self.client.get("/api/products/featured", name="featured_products")
        self.client.get("/api/products/on-sale", name="sale_products")
    
    @task(3)
    def search_products(self):
        """Búsquedas intensivas de productos"""
        search_terms = [
            "laptop", "smartphone", "camera", "headphones", "tablet",
            "book", "shoes", "shirt", "jacket", "watch", "bag"
        ]
        
        term = random.choice(search_terms)
        
        # Búsqueda simple
        self.client.get(f"/api/products/search?q={term}", name="simple_search")
        
        # Búsqueda con filtros
        min_price = random.randint(10, 100)
        max_price = min_price + random.randint(50, 500)
        self.client.get(
            f"/api/products/search?q={term}&minPrice={min_price}&maxPrice={max_price}",
            name="filtered_search"
        )
    
    @task(2)
    def product_details(self):
        """Ver detalles de productos específicos"""
        product_id = random.randint(1, 1000)
        
        # Detalles del producto
        self.client.get(f"/api/products/{product_id}", name="product_details")
        
        # Reviews del producto
        self.client.get(f"/api/products/{product_id}/reviews", name="product_reviews")
        
        # Productos relacionados
        self.client.get(f"/api/products/{product_id}/related", name="related_products")

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
        
        response = self.client.post("/api/orders", json=order_data, headers=headers, name="create_complex_order")
        
        if response.status_code == 201:
            order_id = response.json().get("orderId", random.randint(1, 1000))
            
            # Operaciones sobre la orden
            self.client.get(f"/api/orders/{order_id}", headers=headers, name="get_order")
            self.client.get(f"/api/orders/{order_id}/status", headers=headers, name="order_status_check")
            
            # Actualizar orden (si está permitido)
            update_data = {"status": "processing"}
            self.client.put(f"/api/orders/{order_id}/status", json=update_data, headers=headers, name="update_order_status")
    
    @task(2)
    def order_queries(self):
        """Consultas de órdenes"""
        headers = {"Authorization": f"Bearer {self.auth_token}"}
        
        # Mis órdenes con filtros
        status = random.choice(["pending", "processing", "shipped", "delivered"])
        self.client.get(f"/api/orders/my-orders?status={status}", headers=headers, name="orders_by_status")
        
        # Órdenes por fecha
        days_ago = random.randint(1, 30)
        self.client.get(f"/api/orders/my-orders?days={days_ago}", headers=headers, name="orders_by_date")
        
        # Estadísticas de órdenes
        self.client.get("/api/orders/stats", headers=headers, name="order_statistics")

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
        response = self.client.post("/api/payments", json=payment_data, headers=headers, name="process_payment")
        
        if response.status_code == 200:
            payment_id = response.json().get("paymentId", random.randint(1, 1000))
            
            # Verificar estado del pago
            self.client.get(f"/api/payments/{payment_id}", headers=headers, name="payment_status")
            
            # Historial de pagos
            self.client.get("/api/payments/history", headers=headers, name="payment_history")
    
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
        self.client.post("/api/payments/validate-card", json=card_data, headers=headers, name="validate_card")
        
        # Verificar límites
        amount_data = {"amount": random.uniform(100.0, 5000.0), "currency": "USD"}
        self.client.post("/api/payments/check-limits", json=amount_data, headers=headers, name="check_payment_limits")

class HealthCheckUser(HttpUser):
    """Usuario para monitorear health checks de todos los servicios"""
    wait_time = between(5, 10)
    
    @task(1)
    def check_all_services(self):
        """Verificar salud de todos los microservicios"""
        services = [
            ("service-discovery", 8761),
            ("user-service", 8080),
            ("product-service", 8081),
            ("order-service", 8082),
            ("payment-service", 8083),
            ("shipping-service", 8084)
        ]
        
        for service_name, port in services:
            # Health check endpoint
            self.client.get(f"/actuator/health", name=f"{service_name}_health")
            
            # Metrics endpoint
            self.client.get(f"/actuator/metrics", name=f"{service_name}_metrics")
            
            # Info endpoint
            self.client.get(f"/actuator/info", name=f"{service_name}_info")

# Configuración para diferentes tipos de carga
class LightLoadUser(EcommerceUser):
    """Usuario para carga ligera"""
    wait_time = between(3, 8)
    weight = 1

class HeavyLoadUser(EcommerceUser):
    """Usuario para carga pesada"""
    wait_time = between(0.5, 2)
    weight = 3

class SpikeLoadUser(EcommerceUser):
    """Usuario para picos de carga"""
    wait_time = between(0.1, 1)
    weight = 5

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
        self.client.get("/api/products/quick-search?q=phone", headers=headers, name="mobile_quick_search")
        
        # Ver ofertas flash
        self.client.get("/api/products/flash-deals", headers=headers, name="mobile_flash_deals")
        
        # Notificaciones push
        self.client.post("/api/notifications/register", 
                        json={"deviceToken": f"token_{random.randint(1000, 9999)}"},
                        headers=headers,
                        name="mobile_push_register")

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
            "user_classes": [SpikeLoadUser, MobileAppUser]
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