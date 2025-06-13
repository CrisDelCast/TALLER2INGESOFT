package com.selimhorri.app.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.selimhorri.app.domain.Cart;
import com.selimhorri.app.domain.Order;
import com.selimhorri.app.dto.CartDto;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.exception.wrapper.OrderNotFoundException;
import com.selimhorri.app.repository.OrderRepository;

@ExtendWith(MockitoExtension.class)
class OrderServiceImplTest {

    @Mock
    private OrderRepository orderRepository;

    @InjectMocks
    private OrderServiceImpl orderService;

    private Order sampleOrder;
    private OrderDto sampleOrderDto;

    @BeforeEach
    void setUp() {
        Cart cart = Cart.builder()
                .cartId(5)
                .userId(77)
                .build();

        sampleOrder = Order.builder()
                .orderId(1)
                .orderDate(LocalDateTime.now())
                .orderDesc("Compra de prueba")
                .orderFee(150.0)
                .cart(cart)
                .build();

        CartDto cartDto = CartDto.builder()
                .cartId(5)
                .userId(77)
                .build();

        sampleOrderDto = OrderDto.builder()
                .orderId(1)
                .orderDate(sampleOrder.getOrderDate())
                .orderDesc("Compra de prueba")
                .orderFee(150.0)
                .cartDto(cartDto)
                .build();
    }

    @Test
    @DisplayName("findAll devuelve lista de OrderDto")
    void testFindAll() {
        when(orderRepository.findAll()).thenReturn(List.of(sampleOrder));

        List<OrderDto> result = orderService.findAll();

        assertEquals(1, result.size());
        assertEquals(sampleOrderDto.getOrderDesc(), result.get(0).getOrderDesc());
        verify(orderRepository).findAll();
    }

    @Test
    @DisplayName("findById éxito")
    void testFindByIdSuccess() {
        when(orderRepository.findById(1)).thenReturn(Optional.of(sampleOrder));

        OrderDto result = orderService.findById(1);

        assertNotNull(result);
        assertEquals(sampleOrderDto.getOrderFee(), result.getOrderFee());
        verify(orderRepository).findById(1);
    }

    @Test
    @DisplayName("findById no encontrado")
    void testFindByIdNotFound() {
        when(orderRepository.findById(2)).thenReturn(Optional.empty());

        assertThrows(OrderNotFoundException.class, () -> orderService.findById(2));
        verify(orderRepository).findById(2);
    }

    @Test
    @DisplayName("save persiste y retorna OrderDto")
    void testSave() {
        when(orderRepository.save(any(Order.class))).thenReturn(sampleOrder);

        OrderDto result = orderService.save(sampleOrderDto);

        assertEquals(sampleOrderDto.getOrderId(), result.getOrderId());
        verify(orderRepository).save(any(Order.class));
    }

    @Test
    @DisplayName("update(OrderDto) actualiza y devuelve OrderDto")
    void testUpdateOrderDto() {
        when(orderRepository.save(any(Order.class))).thenReturn(sampleOrder);

        OrderDto result = orderService.update(sampleOrderDto);

        assertEquals(sampleOrderDto.getOrderDesc(), result.getOrderDesc());
        verify(orderRepository).save(any(Order.class));
    }

    @Test
    @DisplayName("update(orderId, OrderDto) llama findById y save")
    void testUpdateById() {
        when(orderRepository.findById(1)).thenReturn(Optional.of(sampleOrder));
        when(orderRepository.save(any(Order.class))).thenReturn(sampleOrder);

        OrderDto result = orderService.update(1, sampleOrderDto);

        assertEquals(sampleOrderDto.getOrderFee(), result.getOrderFee());
        verify(orderRepository).findById(1);
        verify(orderRepository).save(any(Order.class));
    }

    @Test
    @DisplayName("deleteById elimina order")
    void testDeleteById() {
        when(orderRepository.findById(1)).thenReturn(Optional.of(sampleOrder));
        doNothing().when(orderRepository).delete(any(Order.class));

        orderService.deleteById(1);

        verify(orderRepository).findById(1);
        verify(orderRepository).delete(any(Order.class));
    }
} 