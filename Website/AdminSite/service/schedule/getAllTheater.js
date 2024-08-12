const url = "http://localhost:8083/cinema/getAllMovieTheater";

export async function getAllMovieTheater() {
  try {
   
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      }
    });

    const theaterData = await response.json();
    if(response.status==200){
        if (theaterData.code == 1000) {
            return theaterData.result;
          }
    }
    
    return null;
  } catch (error) {
    console.error("Error fetching and displaying theater:", error);
  }
}

