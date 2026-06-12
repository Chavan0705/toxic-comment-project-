/**
 * Learning Dashboard - Main Client-Side JavaScript
 * Handles form validation, responsiveness, and interactive elements.
 */

document.addEventListener("DOMContentLoaded", function () {
    // 1. Mobile Menu Toggle
    const navToggle = document.getElementById("navToggle");
    const navMenu = document.getElementById("navMenu");
    
    if (navToggle && navMenu) {
        navToggle.addEventListener("click", function () {
            navMenu.classList.toggle("active");
            navToggle.classList.toggle("active");
        });
    }

    // 2. Alert Dismissal
    const alerts = document.querySelectorAll(".alert");
    alerts.forEach(function (alert) {
        // Double-click or timeout to dismiss alerts
        alert.addEventListener("click", function () {
            alert.style.opacity = "0";
            setTimeout(() => alert.remove(), 300);
        });
        
        // Auto-dismiss after 6 seconds
        setTimeout(() => {
            if (alert.parentNode) {
                alert.style.opacity = "0";
                setTimeout(() => alert.remove(), 300);
            }
        }, 6000);
    });

    // 3. Password Strength Validation (Register Page)
    const registerForm = document.getElementById("registerForm");
    if (registerForm) {
        const passwordInput = document.getElementById("password");
        const confirmPasswordInput = document.getElementById("confirmPassword");
        const pwdError = document.getElementById("passwordError");

        registerForm.addEventListener("submit", function (e) {
            let errors = [];
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            // Password strength checks
            if (password.length < 8) {
                errors.push("Password must be at least 8 characters long.");
            }
            if (!/[A-Z]/.test(password)) {
                errors.push("Password must contain at least one uppercase letter.");
            }
            if (!/[a-z]/.test(password)) {
                errors.push("Password must contain at least one lowercase letter.");
            }
            if (!/[0-9]/.test(password)) {
                errors.push("Password must contain at least one number.");
            }
            if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
                errors.push("Password must contain at least one special character.");
            }
            if (password !== confirmPassword) {
                errors.push("Passwords do not match.");
            }

            if (errors.length > 0) {
                e.preventDefault();
                pwdError.innerHTML = errors.join("<br>");
                pwdError.style.display = "block";
                window.scrollTo(0, 0);
            } else {
                pwdError.style.display = "none";
            }
        });
    }

    // 4. Admin Course Form Validation
    const courseForm = document.getElementById("courseForm");
    if (courseForm) {
        const ratingInput = document.getElementById("rating");
        const priceInput = document.getElementById("price");
        const durationInput = document.getElementById("duration_hours");
        const formError = document.getElementById("formError");

        courseForm.addEventListener("submit", function (e) {
            let errors = [];
            const rating = parseFloat(ratingInput.value);
            const price = parseFloat(priceInput.value);
            const duration = parseInt(durationInput.value);

            if (isNaN(rating) || rating < 0 || rating > 5) {
                errors.push("Rating must be a decimal between 0 and 5.");
            }
            if (isNaN(price) || price < 0) {
                errors.push("Price cannot be negative.");
            }
            if (isNaN(duration) || duration < 0) {
                errors.push("Duration hours cannot be negative.");
            }

            if (errors.length > 0) {
                e.preventDefault();
                if (formError) {
                    formError.innerHTML = errors.join("<br>");
                    formError.style.display = "block";
                } else {
                    alert(errors.join("\n"));
                }
                window.scrollTo(0, 0);
            }
        });
    }
});

// 5. Delete Confirmations (Global Utility Helper)
function confirmDelete(message, deleteUrl) {
    if (confirm(message || "Are you sure you want to delete this item?")) {
        window.location.href = deleteUrl;
    }
}
