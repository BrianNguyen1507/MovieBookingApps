package com.lepham.cinema.service.imp;

import com.lepham.cinema.converter.CategoryConverter;
import com.lepham.cinema.converter.DateConverter;
import com.lepham.cinema.converter.FilmConverter;
import com.lepham.cinema.dto.request.FilmRequest;
import com.lepham.cinema.dto.response.FilmResponse;
import com.lepham.cinema.entity.FilmEntity;
import com.lepham.cinema.exception.AppException;
import com.lepham.cinema.exception.ErrorCode;
import com.lepham.cinema.repository.FilmRepository;
import com.lepham.cinema.service.IFilmService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FilmService implements IFilmService {

    FilmRepository filmRepository;

    FilmConverter filmConverter;

    CategoryConverter categoryConverter;

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<FilmResponse> getAllFilmByStep(int step) {
        //Find by step
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR)-step);
		Date dateStart =calendar.getTime();
		calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR)+step);
		Date dateEnd =calendar.getTime();
        List<FilmEntity> entities = filmRepository.findAllByReleasDate(dateStart,dateEnd);
        return entities.stream().map(filmConverter::toFilmResponse).collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public List<FilmResponse> getAllFilm() {
        List<FilmEntity> entities = filmRepository.findAllByHide(false);
        return entities.stream().map(filmConverter::toFilmResponse).collect(Collectors.toList());
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FilmResponse getFilmById(long id) {
        FilmEntity filmEntity = filmRepository.findById(id).orElseThrow(()->new AppException(ErrorCode.FILM_NOT_FOUND));
        if(filmEntity.isHide())throw new AppException(ErrorCode.FILM_NOT_FOUND);
        return filmConverter.toFilmResponse(filmEntity);
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FilmResponse addFilm(FilmRequest request) throws ParseException {
       FilmEntity entity = filmConverter.toFilmEntity(request);
       entity.setHide(false);
       return filmConverter.toFilmResponse(filmRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public FilmResponse updateFilm(long id,FilmRequest request) throws ParseException {
        FilmEntity entity = filmRepository.getReferenceById(id);
        entity.setActor(request.getActor());
        entity.setCountry(request.getCountry());
        entity.setDescription(request.getDescription());
        entity.setDirector(request.getDirector());
        entity.setDuration(request.getDuration());
        entity.setBasePrice(request.getBasePrice());
        entity.setLanguage(request.getLanguage());
        entity.setPoster(request.getPoster());
        entity.setReleaseDate(request.getReleaseDate());
        entity.setTrailer(request.getTrailer());
        entity.setTitle(request.getTitle());
        entity.setClassify(request.getClassify());
        entity.setCategories(categoryConverter.toListEntities(request.getCategories()));
        return filmConverter.toFilmResponse(filmRepository.save(entity));
    }

    @Override
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteFilm(long id) {
        FilmEntity entity = filmRepository.findById(id).orElseThrow(()->
                new AppException(ErrorCode.FILM_NOT_FOUND));
        entity.setHide(true);
        filmRepository.save(entity);
    }
}
