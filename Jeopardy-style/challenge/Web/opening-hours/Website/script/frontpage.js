$(document).ready(function () {
    const allCompanies = [];


    var database = firebase.database();

    var companyList = document.getElementById('companyList');
    var searchField = document.getElementById('search');
    searchField.addEventListener('input', function (data) {

        clearList(companyList);

        if (this.value !== '') {
            // Find all elements in list
            for (let i = 0; i < allCompanies.length; i++) {
                if (allCompanies[i].val().name.toLowerCase().includes(this.value.toLowerCase())) {
                    let my_div = createListItem(allCompanies[i].key, allCompanies[i].val());
                    companyList.appendChild(my_div);

                    let hr = document.createElement('hr');
                    companyList.appendChild(hr);
                }
            }
        }
    });


    var db_ref = database.ref('companies').orderByChild('created');
    db_ref.on('child_added', function (snapshot) {


        allCompanies.push(snapshot);
        //clearList(companyList);
        //setCompleteList();

    });

    function setCompleteList() {
        allCompanies.sort(function (x, y) {
            return y.val().created - x.val().created;
        });

        for (let i = 0; i < allCompanies.length; i++) {
            let my_div = createListItem(allCompanies[i].key, allCompanies[i].val());
            companyList.appendChild(my_div);

            let hr = document.createElement('hr');
            companyList.appendChild(hr);
        }
    }

    // Alfabet
    $('.btn-light').click(function () {
        clearList(companyList);
        // Find all elements in list
        for (let i = 0; i < allCompanies.length; i++) {
            if (allCompanies[i].val().name.toLowerCase().startsWith($(this).text().toLowerCase()) || $(this).text() ==='Alle') {
                let my_div = createListItem(allCompanies[i].key, allCompanies[i].val());
                companyList.appendChild(my_div);

                let hr = document.createElement('hr');
                companyList.appendChild(hr);
            }
        }
    });


});

function createListItem(key, data) {
    let my_div = document.createElement('div');
    my_div.setAttribute('class', 'row');

    // Image part
    let image_div = document.createElement('div');
    image_div.setAttribute('class', 'col-md-4 d-flex justify-content-center');
    let a = document.createElement('a');
    a.setAttribute('href', './company.html?id=' + key);
    let logo_image = document.createElement('img');
    logo_image.setAttribute('class', 'img-fluid rounded mb-3 mb-md-0');
    logo_image.setAttribute('src', data.image);

    a.appendChild(logo_image);
    image_div.appendChild(a);
    my_div.appendChild(image_div);


    // Details
    let content_div = document.createElement('div');
    content_div.setAttribute('class', 'col-md-8');
    let title = document.createElement('h3');
    title.innerHTML = data.name;

    content_div.appendChild(title);

    // Table with Opening hours
    let table_div = document.createElement('div');
    table_div.setAttribute('class', 'row');
    let table = document.createElement('table');
    table.setAttribute('class', 'table-responsive left15');

    // Monday and Saturday
    let row1 = table.insertRow(0);
    produceSingleTableRow(row1, "Mandag", data.hours.monday);

    // Tuesday and Holidays
    let row2 = table.insertRow(1);
    produceSingleTableRow(row2, "Tirsdag", data.hours.tuesday);

    // Wednesday
    let row3 = table.insertRow(2);
    produceSingleTableRow(row3, "Onsdag", data.hours.wednesday);

    // Thursday
    let row4 = table.insertRow(3);
    produceSingleTableRow(row4, "Torsdag", data.hours.thursday);

    // Friday
    let row5 = table.insertRow(4);
    produceSingleTableRow(row5, "Fredag", data.hours.friday);

    // Saturday
    let row6 = table.insertRow(5);
    produceSingleTableRow(row6, "Lørdag", data.hours.saturday);

    // Sunday
    let row7 = table.insertRow(6);
    produceSingleTableRow(row7, "Søndag & Helligdage", data.hours.sunday);


    table_div.appendChild(table);
    content_div.appendChild(table_div);
    my_div.appendChild(content_div);

    return my_div;

}

function createListItem_old(key, data) {
    let my_div = document.createElement('div');
    my_div.setAttribute('class', 'row');

    // Image part
    let image_div = document.createElement('div');
    image_div.setAttribute('class', 'col-md-4');
    let a = document.createElement('a');
    a.setAttribute('href', './company.html?id=' + key);
    let logo_image = document.createElement('img');
    logo_image.setAttribute('class', 'img-fluid rounded mb-3 mb-md-0');
    logo_image.setAttribute('src', data.image);

    a.appendChild(logo_image);
    image_div.appendChild(a);
    my_div.appendChild(image_div);


    // Details
    let content_div = document.createElement('div');
    content_div.setAttribute('class', 'col-md-8');
    let title = document.createElement('h3');
    title.innerHTML = data.name;

    content_div.appendChild(title);

    // Table with Opening hours
    let table_div = document.createElement('div');
    table_div.setAttribute('class', 'row');
    let table = document.createElement('table');
    table.setAttribute('class', 'table-responsive');

    // Monday and Saturday
    let row1 = table.insertRow(0);
    produceDoubleTableRow(row1, "Mandag", data.hours.monday, "Lørdag", data.hours.saturday);

    // Tuesday and Holidays
    let row2 = table.insertRow(1);
    produceDoubleTableRow(row2, "Tirsdag", data.hours.tuesday, "Søndag & Helligdage", data.hours.sunday);

    // Wednesday
    let row3 = table.insertRow(2);
    produceSingleTableRow(row3, "Onsdag", data.hours.wednesday);

    // Thursday
    let row4 = table.insertRow(3);
    produceSingleTableRow(row4, "Torsdag", data.hours.thursday);

    // Friday
    let row5 = table.insertRow(4);
    produceSingleTableRow(row5, "Fredag", data.hours.friday);


    table_div.appendChild(table);
    content_div.appendChild(table_div);
    my_div.appendChild(content_div);

    return my_div;

}

function produceDoubleTableRow(row, weekDayOne, openingHoursOne, weekDayTwo, openingHoursTwo) {
    let span_1 = document.createElement('span');
    span_1.setAttribute('class', 'col-1');


    let span_2 = document.createElement('span');
    span_2.setAttribute('class', 'col-2');


    let cell1 = row.insertCell(0);
    let h_tue = document.createElement('h5');
    h_tue.innerHTML = weekDayOne + ":";
    cell1.appendChild(h_tue);

    let cell2 = row.insertCell(1);
    cell2.appendChild(span_1);

    let cell3 = row.insertCell(2);
    let time_label_tue = document.createElement('label');
    time_label_tue.innerHTML = openingHoursOne;
    cell3.appendChild(time_label_tue);

    let cell4 = row.insertCell(3);
    cell4.appendChild(span_2);



    let cell5 = row.insertCell(4);
    let h_sun = document.createElement('h5');
    h_sun.innerHTML = weekDayTwo + ":";
    cell5.appendChild(h_sun);

    let cell6 = row.insertCell(5);
    cell6.appendChild(span_1);

    let cell7 = row.insertCell(6);
    let time_label_sun = document.createElement('label');
    time_label_sun.innerHTML = openingHoursTwo;
    cell7.appendChild(time_label_sun);
}


function produceSingleTableRow(row, weekDay, openingHours) {
    let cell1 = row.insertCell(0);
    let h = document.createElement('h5');
    h.innerHTML = weekDay + ":";
    cell1.appendChild(h);

    let cell2 = row.insertCell(1);
    let span = document.createElement('span');
    span.setAttribute('class', 'col-1');
    cell2.appendChild(span);

    let cell3 = row.insertCell(2);
    let time_label = document.createElement('label');
    time_label.innerHTML = openingHours;
    cell3.appendChild(time_label);
}


function clearList(node) {
    while (node.hasChildNodes()) {
        node.removeChild(node.lastChild);
    }
}