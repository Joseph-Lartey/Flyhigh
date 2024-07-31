<?php
class Flight {
    private $conn;
    private $table_name = "flights";

    public $flight_id;
    public $airline;
    public $flight_number;
    public $departure_country_id;
    public $arrival_country_id;
    public $departure_airport;
    public $arrival_airport;
    public $departure_time;
    public $arrival_time;
    public $duration;
    public $price_business;
    public $price_economy;
    public $price_elite;
    public $seats_available_business;
    public $seats_available_economy;
    public $seats_available_elite;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function searchFlights($departure_country_id, $arrival_country_id, $departure_date, $flexible_days = 3) {
        $query = "SELECT * FROM " . $this->table_name . " 
                  WHERE departure_country_id = :departure_country_id 
                  AND arrival_country_id = :arrival_country_id 
                  AND DATE(departure_time) BETWEEN DATE_SUB(:departure_date, INTERVAL :flexible_days DAY) 
                  AND DATE_ADD(:departure_date, INTERVAL :flexible_days DAY)";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":departure_country_id", $departure_country_id);
        $stmt->bindParam(":arrival_country_id", $arrival_country_id);
        $stmt->bindParam(":departure_date", $departure_date);
        $stmt->bindParam(":flexible_days", $flexible_days);

        $stmt->execute();
        return $stmt;
    }

    public function bookFlight($user_id, $flight_id, $class_id, $num_people, $weight) {
        $query = "INSERT INTO bookings (user_id, flight_id, class_id, weight, status)
                  VALUES (:user_id, :flight_id, :class_id, :weight, 'booked')";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":user_id", $user_id);
        $stmt->bindParam(":flight_id", $flight_id);
        $stmt->bindParam(":class_id", $class_id);
        $stmt->bindParam(":weight", $weight);

        if ($stmt->execute()) {
            return true;
        }
        return false;
    }

    public function updateSeatAvailability($flight_id, $class_id, $num_people) {
        $class_column = "";
        switch ($class_id) {
            case 1:
                $class_column = "seats_available_business";
                break;
            case 2:
                $class_column = "seats_available_economy";
                break;
            case 3:
                $class_column = "seats_available_elite";
                break;
        }

        $query = "UPDATE " . $this->table_name . " 
                  SET " . $class_column . " = " . $class_column . " - :num_people 
                  WHERE flight_id = :flight_id";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":num_people", $num_people);
        $stmt->bindParam(":flight_id", $flight_id);

        if ($stmt->execute()) {
            return true;
        }
        return false;
    }
}
?>
