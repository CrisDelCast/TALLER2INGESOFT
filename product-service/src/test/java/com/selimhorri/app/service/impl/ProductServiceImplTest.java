package com.selimhorri.app.service.impl;

// ... existing code ... 

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.selimhorri.app.domain.Category;
import com.selimhorri.app.domain.Product;
import com.selimhorri.app.dto.CategoryDto;
import com.selimhorri.app.dto.ProductDto;
import com.selimhorri.app.exception.wrapper.ProductNotFoundException;
import com.selimhorri.app.repository.ProductRepository;

@ExtendWith(MockitoExtension.class)
class ProductServiceImplTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductServiceImpl productService;

    private Product sampleProduct;
    private ProductDto sampleProductDto;

    @BeforeEach
    void setUp() {
        Category category = Category.builder()
                .categoryId(100)
                .categoryTitle("Electrónica")
                .imageUrl("http://example.com/cat.jpg")
                .build();

        sampleProduct = Product.builder()
                .productId(1)
                .productTitle("Laptop")
                .imageUrl("http://example.com/laptop.jpg")
                .sku("SKU123")
                .priceUnit(999.99)
                .quantity(7)
                .category(category)
                .build();

        CategoryDto categoryDto = CategoryDto.builder()
                .categoryId(100)
                .categoryTitle("Electrónica")
                .imageUrl("http://example.com/cat.jpg")
                .build();

        sampleProductDto = ProductDto.builder()
                .productId(1)
                .productTitle("Laptop")
                .imageUrl("http://example.com/laptop.jpg")
                .sku("SKU123")
                .priceUnit(999.99)
                .quantity(7)
                .categoryDto(categoryDto)
                .build();
    }

    @Test
    @DisplayName("findAll debe devolver lista mapeada de ProductDto")
    void testFindAll() {
        when(productRepository.findAll()).thenReturn(List.of(sampleProduct));

        List<ProductDto> result = productService.findAll();

        assertEquals(1, result.size());
        assertEquals(sampleProductDto.getProductId(), result.get(0).getProductId());
        verify(productRepository).findAll();
    }

    @Test
    @DisplayName("findById debe devolver ProductDto cuando existe")
    void testFindByIdSuccess() {
        when(productRepository.findById(1)).thenReturn(Optional.of(sampleProduct));

        ProductDto result = productService.findById(1);

        assertNotNull(result);
        assertEquals(sampleProductDto.getSku(), result.getSku());
        verify(productRepository).findById(1);
    }

    @Test
    @DisplayName("findById debe lanzar excepción cuando no existe")
    void testFindByIdNotFound() {
        when(productRepository.findById(2)).thenReturn(Optional.empty());

        assertThrows(ProductNotFoundException.class, () -> productService.findById(2));
        verify(productRepository).findById(2);
    }

    @Test
    @DisplayName("save debe persistir y retornar ProductDto")
    void testSave() {
        when(productRepository.save(any(Product.class))).thenReturn(sampleProduct);

        ProductDto result = productService.save(sampleProductDto);

        assertEquals(sampleProductDto.getProductTitle(), result.getProductTitle());
        verify(productRepository).save(any(Product.class));
    }

    @Test
    @DisplayName("update(ProductDto) debe actualizar y retornar ProductDto")
    void testUpdateProductDto() {
        when(productRepository.save(any(Product.class))).thenReturn(sampleProduct);

        ProductDto result = productService.update(sampleProductDto);

        assertEquals(sampleProductDto.getPriceUnit(), result.getPriceUnit());
        verify(productRepository).save(any(Product.class));
    }

    @Test
    @DisplayName("update(productId, ProductDto) debe llamar a findById y save")
    void testUpdateById() {
        when(productRepository.findById(1)).thenReturn(Optional.of(sampleProduct));
        when(productRepository.save(any(Product.class))).thenReturn(sampleProduct);

        ProductDto result = productService.update(1, sampleProductDto);

        assertEquals(sampleProductDto.getQuantity(), result.getQuantity());
        verify(productRepository).findById(1);
        verify(productRepository).save(any(Product.class));
    }

    @Test
    @DisplayName("deleteById debe eliminar producto existente")
    void testDeleteById() {
        when(productRepository.findById(1)).thenReturn(Optional.of(sampleProduct));
        doNothing().when(productRepository).delete(any(Product.class));

        productService.deleteById(1);

        verify(productRepository).findById(1);
        verify(productRepository).delete(any(Product.class));
    }
} 