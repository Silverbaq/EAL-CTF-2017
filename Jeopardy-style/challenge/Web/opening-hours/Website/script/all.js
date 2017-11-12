$(document).ready(function () {

    const allCompanies = [];

    var location = document.getElementById('location');
    var companies = document.getElementById('companyList');

    var database = firebase.database();

    var db_ref = database.ref('companies');
    db_ref.on('child_added', function (snapshot) {

        let param = getUrlParameter('id');
        location.innerHTML = param;

        if (snapshot.val().location.toLowerCase() === param.toLowerCase()) {
            // Adds to list
            allCompanies.push(snapshot);

            var comp = allCompanies.sort(function(a, b){
                var nameA=a.val().name.toLowerCase(), nameB=b.val().name.toLowerCase();
                if (nameA < nameB) //sort string ascending
                    return -1;
                if (nameA > nameB)
                    return 1;
                return 0; //default return value (no sorting)
            });


            clearList(companies);

            for (let i = 0; i < comp.length; i++) {


                var a = document.createElement("a");
                var h = document.createElement("h2");


                console.log(comp[i].val());

                a.setAttribute('href', './company.html?id=' + comp[i].key);
                a.appendChild(document.createTextNode(comp[i].val().name));
                h.appendChild(a);

                companies.appendChild(h);

                let hr = document.createElement('hr');
                companies.appendChild(hr);

            }
        }
    });


});

function clearList(node) {
    while (node.hasChildNodes()) {
        node.removeChild(node.lastChild);
    }
}

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};

function createListItem(key, data) {
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