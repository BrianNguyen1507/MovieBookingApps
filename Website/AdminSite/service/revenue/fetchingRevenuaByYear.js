import { getRevenueTotalByYear } from "./getRevenueTotalByYear";

export async function fetchingRevenueByYear(){
    const data = await getRevenueTotalByYear();
    console.log(data);
    const revenue = data[0].revenue;
    const revenueYear = Object.keys(revenue);
    const revenueTotal = Object.values(revenue);
   
    const revenueVn = data[1].revenue;
    const revenueVnTotal = Object.values(revenueVn);
    const revenueZl = data[2].revenue;
    const revenueZlTotal = Object.values(revenueZl);
    var ctx1 = $("#worldwide-sales").get(0).getContext("2d");
    var myChart1 = new Chart(ctx1, {
        type: "bar",
        data: {
            labels:revenueYear,
            datasets: [{
                    label: data[0].type,
                    data: revenueTotal,
                    backgroundColor: "rgba(0, 156, 255, .7)"
                },
                {
                    label: data[1].type,
                    data: revenueVnTotal,
                    backgroundColor: "rgba(0, 156, 255, .5)"
                },
                {
                    label:data[2].type,
                    data:revenueZlTotal,
                    backgroundColor: "rgba(0, 156, 255, .3)"
                }
            ]
            },
        options: {
            responsive: true
        }
    });
    
}
fetchingRevenueByYear();