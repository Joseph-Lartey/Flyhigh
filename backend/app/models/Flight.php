<?php
class Flight {
    private $conn;
    private $table_name = "flight_templates";

    public function __construct($db) {
        $this->conn = $db;
    }

    public function searchFlights($departure_country_id, $arrival_country_id, $departure_date, $flexible_days = 7) {
        $start_date = new DateTime($departure_date);
        $end_date = clone $start_date;
        $end_date->modify("+$flexible_days days");

        $query = "SELECT * FROM " . $this->table_name . "
                  WHERE departure_country_id = :departure_country_id 
                  AND arrival_country_id = :arrival_country_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":departure_country_id", $departure_country_id);
        $stmt->bindParam(":arrival_country_id", $arrival_country_id);
        $stmt->execute();

        $flight_templates = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $generated_flights = $this->generateFlights($flight_templates, $start_date, $end_date);

        return $generated_flights;
    }

    private function generateFlights($templates, $start_date, $end_date) {
        $generated_flights = [];
        $current_date = clone $start_date;

        while ($current_date <= $end_date) {
            foreach ($templates as $template) {
                if ($template['departure_day_of_week'] == $current_date->format('N')) {
                    $flight = $template;
                    $flight['departure_date'] = $current_date->format('Y-m-d');
                    $arrival_date = clone $current_date;
                    if ($template['arrival_day_of_week'] < $template['departure_day_of_week']) {
                        $arrival_date->modify('+1 week');
                    }
                    $arrival_date->setISODate($arrival_date->format('Y'), $arrival_date->format('W'), $template['arrival_day_of_week']);
                    $flight['arrival_date'] = $arrival_date->format('Y-m-d');
                    $generated_flights[] = $flight;
                }
            }
            $current_date->modify('+1 day');
        }

        return $generated_flights;
    }
    public function bookFlight($user_id, $template_id, $departure_country_id, $arrival_country_id) {
        $query = "INSERT INTO bookings (user_id, template_id, departure_country_id, arrival_country_id, status, created_at, updated_at)
                  VALUES (:user_id, :template_id, :departure_country_id, :arrival_country_id, 'booked', NOW(), NOW())";
    
        $stmt = $this->conn->prepare($query);
    
        $stmt->bindParam(":user_id", $user_id);
        $stmt->bindParam(":template_id", $template_id);
        $stmt->bindParam(":departure_country_id", $departure_country_id);
        $stmt->bindParam(":arrival_country_id", $arrival_country_id);
    
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


    public function getUserBookings($user_id) {
        $query = "SELECT 
                    b.booking_id, 
                    b.user_id, 
                    b.template_id, 
                    b.departure_country_id, 
                    b.arrival_country_id, 
                    b.status, 
                    b.created_at, 
                    b.updated_at,
                    f.flight_number,
                    f.departure_country AS departure_country_name,
                    f.arrival_country AS arrival_country_name,
                    f.departure_date,
                    f.arrival_date
                  FROM bookings b
                  JOIN flight_templates f ON b.template_id = f.template_id
                  WHERE b.user_id = :user_id";
                  
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":user_id", $user_id);
        $stmt->execute();
    
        $bookings = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
        return $bookings;
    }
    
}
?>