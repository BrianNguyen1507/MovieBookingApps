export class Movie {
  constructor(
    title,
    duration,
    description,
    releaseDate,
    director,
    actor,
    poster,
    trailer,
    country,
    language,
    basePrice,
    categories,
    classify
  ) {
    this.title = title;
    this.duration = duration;
    this.description = description;
    this.releaseDate = releaseDate;
    this.director = director;
    this.actor = actor;
    this.poster = poster;
    this.trailer = trailer;
    this.country = country;
    this.language = language;
    this.basePrice = basePrice;
    this.categories = categories;
    this.classify = classify;
  }
}
