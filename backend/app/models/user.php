<?php
require_once __DIR__ . '/model.php';

/// Class to represent the Users database
class User extends Model
{
    protected $table = 'users';  // Ensure the table name matches
    protected $otherTable = 'tokens';

    // Create single user
    public function createUser($firstname, $lastname, $username, $email, $password, $profile_picture_path = null)
    {
        $password_hash = password_hash($password, PASSWORD_DEFAULT);
        $data = [
            'firstname' => $firstname,
            'lastname' => $lastname,
            'username' => $username,
            'email' => $email,
            'password' => $password_hash,
            'profile_picture_path' => $profile_picture_path,
        ];

        return $this->insert($data);
    }

    // Find a user by their email address
    public function findByEmail($email)
    {
        $result = $this->find("email", $email);
        return $result;
    }

    // Fetch all users in the system with specific column details (attributes)
    public function fetchAll()
    {
        $sql = "SELECT user_id, firstname, lastname, username, email, profile_picture_path, created_at, updated_at
                FROM {$this->table}";

        $stmt = $this->pdo->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Find a user by their id
    public function findProfileById($id)
    {
        $sql = "SELECT user_id, firstname, lastname, username, email, profile_picture_path, created_at, updated_at 
                FROM {$this->table} 
                WHERE user_id = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['id' => $id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Update user profile image
    public function updateProfileImage($id, $imagePath)
    {
        $sql = "UPDATE {$this->table} SET profile_picture_path = :profile_picture_path, updated_at = CURRENT_TIMESTAMP WHERE user_id = :id";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['profile_picture_path' => $imagePath, 'id' => $id]);
    }


    // Update user profile information
    public function updateProfile($id, $firstname, $lastname, $username)
    {
        $sql = "UPDATE {$this->table} SET firstname = :firstname, lastname = :lastname, username = :username, updated_at = CURRENT_TIMESTAMP WHERE user_id = :id";
    
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute([
            'id' => $id,
            'firstname' => $firstname,
            'lastname' => $lastname,
            'username' => $username
        ]);
    }

    // Update password
    public function resetPassword($email, $newPassword)
    {
        $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
        $sql = "UPDATE {$this->table} SET password = :password, updated_at = CURRENT_TIMESTAMP WHERE email = :email";
        $stmt = $this->pdo->prepare($sql);
        return $stmt->execute(['password' => $password_hash, 'email' => $email]);
    }

    public function changePassword($userId, $oldPassword, $newPassword)
    {
        $user = $this->findById($userId);
        
        if ($user && password_verify($oldPassword, $user['password'])) {
            $password_hash = password_hash($newPassword, PASSWORD_DEFAULT);
            $sql = "UPDATE {$this->table} SET password = :password WHERE userId = :userId";
            $stmt = $this->pdo->prepare($sql);
            return $stmt->execute(['password' => $password_hash, 'userId' => $userId]);
        } else {
            return false; // Invalid current password
        }
    }

    public function findById($userId)
    {
        $sql = "SELECT * FROM {$this->table} WHERE userId = :userId";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(['userId' => $userId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}

?>
