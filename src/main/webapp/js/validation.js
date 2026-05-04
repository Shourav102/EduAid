/**
 * EduAid - validation.js
 * Shared client-side validation helper functions used across JSP pages.
 * Note: Server-side validation in ValidationUtil.java is the authoritative check.
 * These functions provide immediate feedback to improve user experience.
 */

/**
 * Checks if an email address has a valid format.
 * @param {string} email
 * @returns {boolean}
 */
function isValidEmail(email) {
    return /^[A-Za-z0-9+_.\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$/.test(email);
}

/**
 * Checks password strength:
 * - Minimum 8 characters
 * - At least one uppercase letter
 * - At least one lowercase letter
 * - At least one digit
 * - At least one special character
 * @param {string} password
 * @returns {boolean}
 */
function isStrongPassword(password) {
    return /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/.test(password);
}

/**
 * Marks a form field as invalid and shows an inline error message.
 * @param {string} fieldId - the input element's id
 * @param {string} message - the error message to display
 */
function markInvalid(fieldId, message) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    field.classList.add('is-invalid');
    field.classList.remove('is-valid');

    // Find or create the error element after the field
    let errorEl = field.parentElement.querySelector('.field-error');
    if (!errorEl) {
        errorEl = document.createElement('div');
        errorEl.className = 'field-error';
        field.parentElement.appendChild(errorEl);
    }
    errorEl.textContent = message;
    errorEl.style.display = 'flex';
}

/**
 * Clears the invalid state from a form field.
 * @param {string} fieldId
 */
function markValid(fieldId) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    field.classList.remove('is-invalid');
    const errorEl = field.parentElement.querySelector('.field-error');
    if (errorEl) errorEl.style.display = 'none';
}

/**
 * Shows a standalone error div by its id.
 * @param {string} errorDivId
 * @param {string} message
 */
function showError(errorDivId, message) {
    const el = document.getElementById(errorDivId);
    if (el) { el.textContent = message; el.style.display = 'flex'; }
}

/**
 * Hides a standalone error div by its id.
 * @param {string} errorDivId
 */
function hideError(errorDivId) {
    const el = document.getElementById(errorDivId);
    if (el) el.style.display = 'none';
}

// ---------------------------------------------------------------
// Mobile Navbar Toggle
// ---------------------------------------------------------------
document.addEventListener('DOMContentLoaded', function () {
    const toggle = document.querySelector('.navbar-toggle');
    const links  = document.querySelector('.navbar-links');
    if (toggle && links) {
        toggle.addEventListener('click', function () {
            links.classList.toggle('open');
        });
    }

    // Close menu when a link is clicked (mobile)
    if (links) {
        links.querySelectorAll('a, button').forEach(function(el) {
            el.addEventListener('click', function() {
                links.classList.remove('open');
            });
        });
    }
});
