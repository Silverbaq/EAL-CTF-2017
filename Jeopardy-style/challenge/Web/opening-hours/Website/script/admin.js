(function () {

    const auth = firebase.auth();

    const txtEmail = document.getElementById('username');
    const txtPassword = document.getElementById('password');
    const btnLogin = document.getElementById('btn-login');
    const btnLogout = document.getElementById('logout');
    const btnAdd = document.getElementById('btnAdd');

    const loginScreen = document.getElementById('div-login');
    const mainDiv = document.getElementById('div-main');

    const txtName = document.getElementById('txtName');
    const txtMonday = document.getElementById('txtMonday');
    const txtTuesday = document.getElementById('txtTuesday');
    const txtWednesday = document.getElementById('txtWednesday');
    const txtThursday = document.getElementById('txtThursday');
    const txtFriday = document.getElementById('txtFriday');
    const txtSaturday = document.getElementById('txtSaturday');
    const txtSunday = document.getElementById('txtSunday');
    const txtText = document.getElementById('txtText');
    const inputImage = document.getElementById('image');
    const locationSelector = document.getElementById('location');

    btnLogin.addEventListener('click', e => {
        const email = txtEmail.value;
        const pass = txtPassword.value;

        const promise = auth.signInWithEmailAndPassword(email, pass);

        promise.catch(e => console.log(e.message));

    });

    btnLogout.addEventListener('click', e => {
        auth.signOut();
    });

    // Add opening hour
    btnAdd.addEventListener('click', e => {
        console.log('clicked!!');
        let name = txtName.value;

        let monday = txtMonday.value;
        let tuesday = txtTuesday.value;
        let wednesday = txtWednesday.value;
        let thursday = txtThursday.value;
        let friday = txtFriday.value;
        let saturday = txtSaturday.value;
        let sunday = txtSunday.value;

        let text = txtText.value;


        let location = locationSelector[locationSelector.selectedIndex].value;
        console.log('data collected');


        // Get file
        let file = inputImage.files[0];
        console.log('got image');

        // Create a storage ref
        let storageRef = firebase.storage().ref('companies/'+ file.name);
        console.log('make ref');

        // Upload file
        let task = storageRef.put(file).then(function (snapshot) {
            // Safe stuff when image is uploaded
            reg = {
                created: Date.now(),
                name: name,
                image: snapshot.downloadURL,
                hours: {
                    monday: monday,
                    tuesday: tuesday,
                    wednesday: wednesday,
                    thursday: thursday,
                    friday: friday,
                    saturday: saturday,
                    sunday: sunday
                },
                location: location,
                new: true,
                text: text
            };

            console.log(reg);

            // Push to firebase database
            firebase.database().ref('companies').push(reg);

            // Clear fields
            clearFields();
        });

    });


    auth.onAuthStateChanged(firebaseUser => {
        if (firebaseUser) {
            console.log(firebaseUser);
            $(loginScreen).hide();
            $(mainDiv).show();

        } else {
            console.log('not logged in');
            $(mainDiv).hide();
            $(loginScreen).show();
        }
    });



    function clearFields() {
        $(txtName).val('');
        $(txtMonday).val('');
        $(txtTuesday).val('');
        $(txtWednesday).val('');
        $(txtThursday).val('');
        $(txtFriday).val('');
        $(txtSaturday).val('');
        $(txtSunday).val('');
        $(txtText).val('');
        inputImage.clear();
    }
}());

