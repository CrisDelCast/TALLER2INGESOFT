package com.selimhorri.app.service.impl;

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

import com.selimhorri.app.domain.Credential;
import com.selimhorri.app.domain.RoleBasedAuthority;
import com.selimhorri.app.domain.User;
import com.selimhorri.app.dto.CredentialDto;
import com.selimhorri.app.dto.UserDto;
import com.selimhorri.app.exception.wrapper.UserObjectNotFoundException;
import com.selimhorri.app.repository.UserRepository;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserServiceImpl userService;

    private User sampleUser;
    private UserDto sampleUserDto;

    @BeforeEach
    void setUp() {
        Credential credential = Credential.builder()
                .credentialId(11)
                .username("jdoe")
                .password("pass")
                .roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
                .isEnabled(true)
                .isAccountNonExpired(true)
                .isAccountNonLocked(true)
                .isCredentialsNonExpired(true)
                .build();

        sampleUser = User.builder()
                .userId(1)
                .firstName("John")
                .lastName("Doe")
                .email("john.doe@example.com")
                .phone("3001234567")
                .imageUrl("http://example.com/avatar.jpg")
                .credential(credential)
                .build();

        credential.setUser(sampleUser); // bidirectional

        CredentialDto credentialDto = CredentialDto.builder()
                .credentialId(11)
                .username("jdoe")
                .password("pass")
                .roleBasedAuthority(RoleBasedAuthority.ROLE_USER)
                .isEnabled(true)
                .isAccountNonExpired(true)
                .isAccountNonLocked(true)
                .isCredentialsNonExpired(true)
                .build();

        sampleUserDto = UserDto.builder()
                .userId(1)
                .firstName("John")
                .lastName("Doe")
                .email("john.doe@example.com")
                .phone("3001234567")
                .imageUrl("http://example.com/avatar.jpg")
                .credentialDto(credentialDto)
                .build();
    }

    @Test
    @DisplayName("findAll debe devolver lista de UserDto")
    void testFindAll() {
        when(userRepository.findAll()).thenReturn(List.of(sampleUser));

        List<UserDto> result = userService.findAll();

        assertEquals(1, result.size());
        assertEquals(sampleUserDto.getEmail(), result.get(0).getEmail());
        verify(userRepository).findAll();
    }

    @Test
    @DisplayName("findById: éxito")
    void testFindByIdSuccess() {
        when(userRepository.findById(1)).thenReturn(Optional.of(sampleUser));

        UserDto result = userService.findById(1);

        assertNotNull(result);
        assertEquals("John", result.getFirstName());
        verify(userRepository).findById(1);
    }

    @Test
    @DisplayName("findById: no encontrado")
    void testFindByIdNotFound() {
        when(userRepository.findById(2)).thenReturn(Optional.empty());

        assertThrows(UserObjectNotFoundException.class, () -> userService.findById(2));
        verify(userRepository).findById(2);
    }

    @Test
    @DisplayName("save debe persistir y devolver UserDto")
    void testSave() {
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);

        UserDto result = userService.save(sampleUserDto);

        assertEquals(sampleUserDto.getLastName(), result.getLastName());
        verify(userRepository).save(any(User.class));
    }

    @Test
    @DisplayName("update(UserDto) debe actualizar y devolver UserDto")
    void testUpdateUserDto() {
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);

        UserDto result = userService.update(sampleUserDto);

        assertEquals(sampleUserDto.getPhone(), result.getPhone());
        verify(userRepository).save(any(User.class));
    }

    @Test
    @DisplayName("update(userId, UserDto) debe llamar a findById y save")
    void testUpdateById() {
        when(userRepository.findById(1)).thenReturn(Optional.of(sampleUser));
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);

        UserDto result = userService.update(1, sampleUserDto);

        assertEquals(sampleUserDto.getUserId(), result.getUserId());
        verify(userRepository).findById(1);
        verify(userRepository).save(any(User.class));
    }

    @Test
    @DisplayName("deleteById debe invocar repository.deleteById")
    void testDeleteById() {
        doNothing().when(userRepository).deleteById(1);

        userService.deleteById(1);

        verify(userRepository).deleteById(1);
    }

    @Test
    @DisplayName("findByUsername debe devolver UserDto cuando existe")
    void testFindByUsernameSuccess() {
        when(userRepository.findByCredentialUsername("jdoe"))
                .thenReturn(Optional.of(sampleUser));

        UserDto result = userService.findByUsername("jdoe");

        assertEquals(sampleUserDto.getEmail(), result.getEmail());
        verify(userRepository).findByCredentialUsername("jdoe");
    }

    @Test
    @DisplayName("findByUsername debe lanzar excepción si no existe")
    void testFindByUsernameNotFound() {
        when(userRepository.findByCredentialUsername("nosuch"))
                .thenReturn(Optional.empty());

        assertThrows(UserObjectNotFoundException.class, () -> userService.findByUsername("nosuch"));
        verify(userRepository).findByCredentialUsername("nosuch");
    }
} 