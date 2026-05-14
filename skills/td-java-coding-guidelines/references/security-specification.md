# Security Specification

## Mandatory

1. **Permission checks**: user-facing pages and features must enforce authorization to prevent unauthorized access or tampering with other users' data, such as viewing or modifying someone else's order.

2. **Sensitive data masking**: sensitive user information must not be displayed directly. It must be masked, for example `158****9119`.

3. **SQL injection prevention**: SQL parameters derived from user input must be strictly validated or constrained through metadata. Do not access the database through string concatenation.

4. **User input validation**: every user input parameter must be validated. Missing validation can lead to:
   - page display errors,
   - SQL injection,
   - parameter-type conversion errors,
   - invalid business data,
   - stored XSS,
   - arbitrary redirects,
   - other security or data-integrity problems.

5. **Output escaping**: user data rendered into HTML pages must be safely filtered or escaped to prevent XSS.

6. **CSRF protection**: form submissions and AJAX submissions must pass CSRF security checks.

7. **Replay prevention**: SMS, email, phone, order, payment, and similar operations must use frequency limits, fatigue controls, CAPTCHA, or equivalent replay-abuse controls.

## Recommended

8. **Risk control for user-generated content**: posts, comments, instant messages, and similar content should use anti-spam, sensitive-word filtering, and other risk-control strategies.
