$(document).ready(function () {

    var database = firebase.database();

    var companyList = document.getElementById('companyList');
    var title = document.getElementById('title');


    var db_ref = database.ref('companies').orderByChild('created');
    db_ref.on('child_added', function (snapshot) {

        var param = getUrlParameter('id');
        title.innerHTML = param;

        if (snapshot.val().name.toLowerCase().startsWith(param.toLowerCase())){
            var a = document.createElement("a");
            var h = document.createElement("h2");

            a.setAttribute('href', './company.html?id=' + snapshot.key);
            a.appendChild(document.createTextNode(snapshot.val().name));
            h.appendChild(a);

            companyList.appendChild(h);


            //companyList.appendChild(createListItem(snapshot.key, snapshot.val()))
            var hr = document.createElement('hr');
            companyList.appendChild(hr);
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


function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

