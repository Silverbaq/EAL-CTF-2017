(function () {

    let image = document.getElementById('company-image');
    let monday = document.getElementById('open-monday');
    let tuesday = document.getElementById('open-tuesday');
    let wednesday = document.getElementById('open-wednesday');
    let thursday = document.getElementById('open-thursday');
    let friday = document.getElementById('open-friday');
    let saturday = document.getElementById('open-saturday');
    let sunday = document.getElementById('open-sunday');
    let text = document.getElementById('company-text');
    let name = document.getElementById('company-name');

    let firebase_ref = firebase.database().ref('companies/'+ getUrlParameter('id'));

    firebase_ref.on('value', snapshot => {
        image.setAttribute('src', snapshot.val().image);
        monday.innerText = snapshot.val().hours.monday;
        tuesday.innerText = snapshot.val().hours.tuesday;
        wednesday.innerText = snapshot.val().hours.wednesday;
        thursday.innerText = snapshot.val().hours.thursday;
        friday.innerText = snapshot.val().hours.friday;
        saturday.innerText = snapshot.val().hours.saturday;
        sunday.innerText = snapshot.val().hours.sunday;
        text.innerText = snapshot.val().text;
        name.innerText = snapshot.val().name;
    });

}());

function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
};