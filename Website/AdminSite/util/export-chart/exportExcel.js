export function exportChartData(type, yearchart, monthchart) {
  const chartDatayear = yearchart.data;
  const chartDataMonth = monthchart.data;
  exportToExcel(
    type === "yearven"
      ? prepareDataForExport(chartDatayear)
      : prepareDataForExport(chartDataMonth),
    type === "yearven" ? "Years-Statistics" : "Months-Statistics"
  );
}

function prepareDataForExport(chartData) {
  const labels = chartData.labels;
  const datasets = chartData.datasets;

  let newData = [["Thống kê", ...datasets.map((ds) => ds.label)]];

  labels.forEach((label, index) => {
    let row = [label];
    datasets.forEach((dataset) => {
      row.push(dataset.data[index]);
    });
    newData.push(row);
  });

  return newData;
}

function exportToExcel(data, title = "data", filename = `${title}.xlsx`) {
  const ws = XLSX.utils.aoa_to_sheet(data);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
  XLSX.writeFile(wb, filename);
}
