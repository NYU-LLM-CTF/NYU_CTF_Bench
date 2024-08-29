/*!
* Start Bootstrap - Freelancer v7.0.5 (https://startbootstrap.com/theme/freelancer)
* Copyright 2013-2021 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-freelancer/blob/master/LICENSE)
*/
//
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {

    // Navbar shrink function
    var navbarShrink = function () {
        const navbarCollapsible = document.body.querySelector('#mainNav');
        if (!navbarCollapsible) {
            return;
        }
        if (window.scrollY === 0) {
            navbarCollapsible.classList.remove('navbar-shrink')
        } else {
            navbarCollapsible.classList.add('navbar-shrink')
        }

    };

    // Shrink the navbar 
    navbarShrink();

    // Shrink the navbar when page is scrolled
    document.addEventListener('scroll', navbarShrink);

    // Activate Bootstrap scrollspy on the main nav element
    const mainNav = document.body.querySelector('#mainNav');
    if (mainNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#mainNav',
            offset: 72,
        });
    };

    // Collapse responsive navbar when toggler is visible
    const navbarToggler = document.body.querySelector('.navbar-toggler');
    const responsiveNavItems = [].slice.call(
        document.querySelectorAll('#navbarResponsive .nav-link')
    );
    responsiveNavItems.map(function (responsiveNavItem) {
        responsiveNavItem.addEventListener('click', () => {
            if (window.getComputedStyle(navbarToggler).display !== 'none') {
                navbarToggler.click();
            }
        });
    });

    document.getElementById('contactForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/contact');

        xhr.setRequestHeader('Content-Type', 'application/json');
        
        var name = document.getElementById('name').value;
        var email = document.getElementById('email').value;
        var phone = document.getElementById('phone').value;
        var message = document.getElementById('message').value;
        var emergency = document.getElementById('emergency').checked;

        var data = `{
        "name": "${name}",
        "email": "${email}",
        "phone": "${phone}",
        "message": "${message}",
        "emergency": ${emergency}
        }`;

        xhr.send(data);

        document.getElementById('submitSuccessMessage').classList.remove('d-none');
        document.getElementById('name').disabled = 'disabled';
        document.getElementById('email').disabled = 'disabled';
        document.getElementById('phone').disabled = 'disabled';
        document.getElementById('message').disabled = 'disabled';
        document.getElementById('emergency').disabled = 'disabled';
        document.getElementById('submitButton').classList.add('d-none');
    });
});
