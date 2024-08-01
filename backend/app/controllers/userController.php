<?php

use Dotenv\Exception\InvalidFileException;

require_once __DIR__ . '/../models/user.php';

// Class to cater for all user oriented actions
class UserController
{
    protected $userModel;

    public function __construct($pdo)
    {
        $this->userModel = new User($pdo);
    }

    // Handle create user action using the user model
    public function createUser($data)
    {
        try {
            $this->userModel->createUser(
                $data['firstname'],
                $data['lastname'],
                $data['username'],
                $data['email'],
                $data['password']
            );

            return ['success' => true];
        } catch (PDOException $pe) {
            if ($pe->getCode() == 23000) {
                header('HTTP/1.1 422 Unprocessable Entity');
                $errors = ["success" => false, "error" => "Email already exists in system"];
                return $errors;
            }
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            $errors = ["success" => false, "error" => $e->getMessage()];
            return $errors;
        }
    }

    // Handle user login action using the user model
    public function login($data)
    {
        try {
            // Fetch user details by email
            $db_details = $this->userModel->findByEmail($data['email']);
    
            if ($db_details == false) { // Throw exception if email is wrong
                throw new InvalidArgumentException("Wrong email.");
            }
    
            $login_password = $data['password'];
            $db_password = $db_details['password'];
    
            if (password_verify($login_password, $db_password)) { // Check if password is correct
                return [
                    "success" => true,
                    "id" => $db_details['user_id'],
                ];
            } else {
                throw new InvalidArgumentException("Wrong password.");
            }
        } catch (InvalidArgumentException $e) { // Handle invalid email or password
            header('HTTP/1.1 422 Unprocessable Entity');
            return [
                "success" => false,
                "error" => $e->getMessage()
            ];
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return [
                "success" => false,
                "error" => $e->getMessage(),
            ];
        }
    }
    

    // Handle request to fetch all users
    public function getAllUsers()
    {
        try {
            // Get all the users in the database
            $users = $this->userModel->fetchAll();

            return ["success" => true, "data" => $users];
        } catch (\Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return [
                "success" => false,
                "error" => $e->getMessage(),
            ];
        }
    }

    // Handle request to get a user by ID
    public function getUserById($userId)
    {
        try {
            $result = $this->userModel->findProfileById($userId);
            if ($result) {
                return $result;
            } else {
                header('HTTP/1.1 404 Not Found');
                return ["success" => false, "error" => "User not found"];
            }
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    // Upload user profile image
    public function uploadProfileImage($id)
{
    try {
        if (!isset($_FILES['profile_images'])) {
            throw new InvalidArgumentException("No image attached");
        }

        $file = $_FILES['profile_images'];
        $dir = __DIR__ . '/../../public/profile_images/';
        
        // Ensure the directory exists
        if (!file_exists($dir)) {
            mkdir($dir, 0777, true);
        }

        $filename = uniqid() . '-' . $id . '.' . pathinfo($file['name'], PATHINFO_EXTENSION);
        $targetFile = $dir . $filename;

        // Move file from temp position to intended directory
        if (!move_uploaded_file($file['tmp_name'], $targetFile)) {
            header('HTTP/1.1 500 Server Error');
            throw new Exception("Error moving image");
        }

        // Update user profile image path in database
        $this->userModel->updateProfileImage($id, $filename);

        return ["success" => true, "message" => "Successful profile upload"];
    } catch (InvalidArgumentException $e) {
        header('HTTP/1.1 422 Unprocessable Entity');
        return ["success" => false, "message" => $e->getMessage()];
    } catch (Exception $e) {
        header('HTTP/1.1 500 Server Error');
        return ["success" => false, "message" => $e->getMessage()];
    }
}
    // Update user profile information
    public function updateProfile($id, $firstname, $lastname, $username)
    {
        try {
            $result = $this->userModel->updateProfile($id, $firstname, $lastname, $username);
            if ($result) {
                return ["success" => true, "message" => "Successful profile update"];
            } else {
                header('HTTP/1.1 404 Not Found');
                return ["success" => false, "error" => "Could not update"];
            }
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }

    public function resetPassword($email, $newPassword)
    {
        try {
            $result = $this->userModel->resetPassword($email, $newPassword);
            if ($result) {
                return ["success" => true, "message" => "Password reset successful"];
            } else {
                header('HTTP/1.1 404 Not Found');
                return ["success" => false, "error" => "Could not reset password"];
            }
        } catch (Exception $e) {
            header('HTTP/1.1 422 Unprocessable Entity');
            return ["success" => false, "error" => $e->getMessage()];
        }
    }
}
?>
