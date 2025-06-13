package com.selimhorri.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.client.RestTemplate;

import com.selimhorri.app.domain.Payment;
import com.selimhorri.app.dto.OrderDto;
import com.selimhorri.app.dto.PaymentDto;
import com.selimhorri.app.exception.wrapper.PaymentNotFoundException;
import com.selimhorri.app.helper.PaymentMappingHelper;
import com.selimhorri.app.repository.PaymentRepository;

@ExtendWith(MockitoExtension.class)
class PaymentServiceImplTest {
	
	@Mock
	private PaymentRepository paymentRepository;
	
	@Mock
	private RestTemplate restTemplate;
	
	@InjectMocks
	private PaymentServiceImpl paymentService;
	
	private Payment payment;
	private PaymentDto paymentDto;
	private OrderDto orderDto;
	
	@BeforeEach
	void setUp() {
		
		this.orderDto = OrderDto.builder()
				.orderId(1)
				.build();
		
		this.payment = Payment.builder()
				.paymentId(1)
				.orderId(1)
				.isPayed(true)
				.paymentStatus("SUCCESS")
				.build();
		
		this.paymentDto = PaymentDto.builder()
				.paymentId(1)
				.orderDto(this.orderDto)
				.isPayed(true)
				.paymentStatus("SUCCESS")
				.build();
	}
	
	@Test
	void findAllShouldReturnListOfPaymentDtos() {
		
		// given
		when(this.paymentRepository.findAll()).thenReturn(Collections.singletonList(this.payment));
		when(this.restTemplate.getForObject(anyString(), any(Class.class))).thenReturn(this.orderDto);
		
		// when
		final List<PaymentDto> paymentDtos = this.paymentService.findAll();
		
		// then
		assertThat(paymentDtos).isNotNull();
		assertThat(paymentDtos.size()).isEqualTo(1);
	}
	
	@Test
	void findByIdShouldReturnPaymentDto() {
		
		// given
		when(this.paymentRepository.findById(anyInt())).thenReturn(Optional.of(this.payment));
		when(this.restTemplate.getForObject(anyString(), any(Class.class))).thenReturn(this.orderDto);
		
		// when
		final PaymentDto pDto = this.paymentService.findById(this.payment.getPaymentId());
		
		// then
		assertThat(pDto).isNotNull();
		assertThat(pDto.getPaymentId()).isEqualTo(this.payment.getPaymentId());
	}
	
	@Test
	void findByIdShouldThrowPaymentNotFoundException() {
		
		// given
		final int paymentId = 0;
		when(this.paymentRepository.findById(anyInt())).thenReturn(Optional.empty());
		
		// when
		assertThrows(PaymentNotFoundException.class, () -> this.paymentService.findById(paymentId));
		
		// then
		
	}
	
	@Test
	void saveShouldReturnSavedPaymentDto() {
		
		// given
		when(this.paymentRepository.save(any(Payment.class))).thenReturn(this.payment);
		
		// when
		final PaymentDto savedPaymentDto = this.paymentService.save(this.paymentDto);
		
		// then
		assertThat(savedPaymentDto).isNotNull();
	}
	
	@Test
	void updateShouldReturnUpdatedPaymentDto() {
		
		// given
		when(this.paymentRepository.save(any(Payment.class))).thenReturn(this.payment);
		
		// when
		final PaymentDto updatedPaymentDto = this.paymentService.update(this.paymentDto);
		
		// then
		assertThat(updatedPaymentDto).isNotNull();
	}
	
	@Test
	void deleteByIdShouldBeDeleted() {
		
		// given
		doNothing().when(this.paymentRepository).deleteById(anyInt());
		
		// when
		this.paymentService.deleteById(this.payment.getPaymentId());
		
		// then
		
	}
	
} 