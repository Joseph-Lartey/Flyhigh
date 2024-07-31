<?php

header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE, PATCH, OPTIONS');
header('Access-Control-Max-Age: 1000');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('content-Type: application/json');

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/app/controllers/userController.php';
require_once __DIR__ . '/app/controllers/ForgetPasswordController.php';
require_once __DIR__ . '/app/middleware/ValidationMiddleWare.php';
require_once __DIR__ . '/app/controllers/ChangePasswordController.php';
require_once __DIR__ . '/app/controllers/BookingController.php';
require_once __DIR__ . '/app/controllers/CountryController.php';

use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

$router = new AltoRouter();
$router->setBasePath('/Flyhigh/backend');

// create database and pdo
$database = new Database();
$pdo = $database->getPdo();

$userController = new UserController($pdo);
$forgetPasswordController = new ForgetPasswordController($pdo);
$changePasswordController = new ChangePasswordController($pdo);
$bookingController = new BookingController();
$countryController = new CountryController($pdo);

// Routes
// Below I will define all the different end points that the user can send requests to

// Cater for user account creation
$router->map('POST', '/user', function () use ($userController) {
    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'firstname' => 'string',
        'lastname' => 'string',
        'username' => 'string',
        'email' => 'email',
        'password' => 'password',
        'confirm_password' => 'confirm_password'
    ]);

    echo json_encode($userController->createUser($data));
});

// Cater for user login
$router->map('POST', '/user/login', function () use ($userController) {
    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'email' => 'string',
        'password' => 'password',
    ]);

    echo json_encode($userController->login($data));
});

// Catering for fetching user details by userId
$router->map('GET', '/user/[*:userId]', function ($userId) use ($userController) {
    ValidationMiddleWare::handle(['userId' => $userId], ['userId' => 'integer']);
    echo json_encode($userController->getUserById($userId));
});

// Cater for fetching all users
$router->map('GET', '/user', function () use ($userController) {
    echo json_encode($userController->getAllUsers());
});

// Upload user profile image
$router->map('POST', '/upload/[*:userId]', function ($userId) use ($userController) {
    $file = $_FILES['profile_image'];
    
    ValidationMiddleWare::handle(["userId" => $userId], ["userId" => "integer"]);
    ValidationMiddleWare::handleImage($file);
    
    echo json_encode($userController->uploadProfileImage($userId));
});

// Update user profile information
$router->map('POST', '/profile', function () use ($userController) {
    $data = json_decode(file_get_contents('php://input'), true);

    //validate data
    ValidationMiddleWare::handle($data, [
        'userId' => 'integer',
        'firstname' => 'string',
        'lastname' => 'string',
        'username' => 'string'
    ]);

    echo json_encode($userController->updateProfile(
        $data['userId'], 
        $data['firstname'], 
        $data['lastname'], 
        $data['username']
    ));
});

// Cater for password change
$router->map('POST', '/user/change_password', function () use ($changePasswordController) {
    $data = json_decode(file_get_contents('php://input'), true);
    ValidationMiddleWare::handle($data, [
        'userId' => 'integer',
        'oldPassword' => 'string',
        'newPassword' => 'string',
        'confirmPassword' => 'string'
    ]);
    echo json_encode($changePasswordController->changePassword($data));
});

// Cater for password reset
$router->map('POST', '/user/reset_password', function () use ($forgetPasswordController) {
    $data = json_decode(file_get_contents('php://input'), true);
    ValidationMiddleWare::handle($data, ['email' => 'email']);
    echo json_encode($forgetPasswordController->resetPassword($data));
});

// Booking Routes
// Search for flights
$router->map('POST', '/flights/search', function () use ($bookingController) {
    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'departure_country_id' => 'integer',
        'arrival_country_id' => 'integer',
        'departure_date' => 'date',
        'flexible_days' => 'integer' // Optional, default will be handled in controller
    ]);

    echo json_encode($bookingController->searchFlights($data));
});

// Book a flight
$router->map('POST', '/flights/book', function () use ($bookingController) {
    $data = json_decode(file_get_contents('php://input'), true);

    // validate data
    ValidationMiddleWare::handle($data, [
        'user_id' => 'integer',
        'flight_id' => 'integer',
        'class_id' => 'integer',
        'num_people' => 'integer',
        'weight' => 'integer'
    ]);

    echo json_encode($bookingController->bookFlight($data));
});

// Fetch all countries
$router->map('GET', '/countries', function () use ($countryController) {
    echo json_encode($countryController->getAllCountries());
});

$match = $router->match();

if ($match && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    http_response_code(404);
    echo json_encode(['status' => 'error', 'message' => 'Route not found']);
}
?>
