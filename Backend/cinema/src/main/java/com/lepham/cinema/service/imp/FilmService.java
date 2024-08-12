package com.lepham.cinema.service.imp;

import com.lepham.cinema.constant.ConstantVariable;
import com.lepham.cinema.converter.FilmConverter;
import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.FilmRepository;
import com.lepham.cinema.service.IFilmService;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FilmService implements IFilmService {

    FilmRepository filmRepository;

    FilmConverter filmConverter;


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<FilmResponse> getAllFilmByStep(int step) {
        //Find by step
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - step);
        Date dateStart = calendar.getTime();
        calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + step);
        Date dateEnd = calendar.getTime();
        List<FilmEntity> entities = filmRepository.findAllByReleasDate(dateStart, dateEnd);
        return entities.stream().map(filmConverter::toFilmResponse).collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<FilmResponse> getAllFilm() {
        List<FilmEntity> entities = filmRepository.findAllByHide(false, Sort.by(Sort.Direction.ASC, "active","releaseDate"));
        return entities.stream().map(filmConverter::toFilmResponse).collect(Collectors.toList());
    }

    @Override
    public FilmResponse getFilmById(long id) {
        FilmEntity filmEntity = filmRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));
        if (filmEntity.isHide()) {
            throw new AppException(ErrorCode.FILM_NOT_FOUND);
        }
        return filmConverter.toFilmResponse(filmEntity);
    }


    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FilmResponse addFilm(FilmRequest request) {
        if (filmRepository.findByTitle(request.getTitle()).isPresent())
            throw new AppException(ErrorCode.FILM_NAME_DUPLICATE);
        FilmEntity entity = filmConverter.toFilmEntity(request);
        entity.setHide(false);
        entity.setActive(ConstantVariable.FILM_RELEASE);
        return filmConverter.toFilmResponse(filmRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FilmResponse updateFilm(long id, FilmRequest request) {
        if (filmRepository.findById(id).isEmpty()) throw new AppException(ErrorCode.FILM_NOT_FOUND);
        if (filmRepository.findByTitleAndIdIsNot(request.getTitle(), id).isPresent())
            throw new AppException(ErrorCode.FILM_NAME_DUPLICATE);
        FilmEntity entity = filmConverter.toFilmEntity(request);
        entity.setId(id);
        return filmConverter.toFilmResponse(filmRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteFilm(long id) {
        FilmEntity entity = filmRepository.findById(id).orElseThrow(() ->
                new AppException(ErrorCode.FILM_NOT_FOUND));
        entity.setHide(true);
        filmRepository.save(entity);
    }

    @Override
    public List<FilmResponse> searchFilm(String textFill) {
        List<FilmEntity> entities = filmRepository.findAllByKeyWord(textFill);

        return entities.stream().map(filmConverter::toFilmResponse).toList();
    }

    @Override
    public List<FilmResponse> getListMovieRelease() {
        List<FilmEntity> entities = filmRepository.findAllMovieRelease();
        return entities.stream().map(filmConverter::toFilmResponse).toList();
    }

    @Override
    public List<FilmResponse> getListMovieFuture() {
        List<FilmEntity> entities = filmRepository.findAllMovieFuture();
        return entities.stream().map(filmConverter::toFilmResponse).toList();
    }

    @Override
    public List<FilmResponse> getListMovieFutureByMonth(int month) {
        List<FilmEntity> entities = filmRepository.findAllMovieByFutureMonth(month);
        return entities.stream().map(filmConverter::toFilmResponse).toList();
    }

    @Override
    public List<FilmResponse> getAllListMovie() {
        List<FilmEntity> entities = filmRepository.findAllByActiveAndHide();
        return entities.stream().map(filmConverter::toFilmResponse).toList();
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public int activeFilm(long id) {
        FilmEntity entity = filmRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.FILM_NOT_FOUND));
        if (entity.getActive() == ConstantVariable.FILM_RELEASE) entity.setActive(ConstantVariable.FILM_STOP_RELEASE);
        else entity.setActive(ConstantVariable.FILM_RELEASE);
        entity = filmRepository.save(entity);
        return entity.getActive();
    }

}

