$(document).ready(function(){

    const allCompanies = [];
    var database = firebase.database();


    // Alfabet
    $('.btn-light').click(function () {
        window.location.href = "./alfabetic.html?id="+this.innerHTML;
    });

    var db_ref = database.ref('companies').orderByChild('created');
    db_ref.on('child_added', function (snapshot) {
        allCompanies.push(snapshot);
    });


    var searchField = document.getElementById('menuSearch');
    var searchResult = document.getElementById('menuSearchResult');

    searchField.addEventListener('input', function (data) {

        clearList(searchResult);

        if (this.value !== '') {
            // Find all elements in list
            for (let i = 0; i < allCompanies.length; i++) {
                if (allCompanies[i].val().name.toLowerCase().includes(this.value.toLowerCase())) {

                    var a = document.createElement("a");
                    var li = document.createElement("li");

                    a.setAttribute('href', './company.html?id=' + allCompanies[i].key);
                    a.innerHTML = allCompanies[i].val().name;
                    li.appendChild(a);

                    searchResult.appendChild(li);

                    let hr = document.createElement('hr');
                    searchResult.appendChild(hr);
                }
            }
        }
    });


    function clearList(node) {
        while (node.hasChildNodes()) {
            node.removeChild(node.lastChild);
        }
    }

}());