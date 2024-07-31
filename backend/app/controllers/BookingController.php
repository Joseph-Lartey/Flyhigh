<?php
require_once '../../config/database.php';
require_once '../models/Flight.php';

class BookingController {
    private $db;
    private $flight;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getPdo();
        $this->flight = new Flight($this->db);
    }

    public function searchFlights($data) {
        $departure_country_id = $data['departure_country_id'];
        $arrival_country_id = $data['arrival_country_id'];
        $departure_date = $data['departure_date'];
        $flexible_days = isset($data['flexible_days']) ? $data['flexible_days'] : 3; // Default to 3 days flexibility

        $stmt = $this->flight->searchFlights($departure_country_id, $arrival_country_id, $departure_date, $flexible_days);

        $flights = array();
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            extract($row);
            $flight_item = array(
                "flight_id" => $flight_id,
                "airline" => $airline,
                "flight_number" => $flight_number,
                "departure_country_id" => $departure_country_id,
                "arrival_country_id" => $arrival_country_id,
                "departure_airport" => $departure_airport,
                "arrival_airport" => $arrival_airport,
                "departure_time" => $departure_time,
                "arrival_time" => $arrival_time,
                "duration" => $duration,
                "price_business" => $price_business,
                "price_economy" => $price_economy,
                "price_elite" => $price_elite,
                "seats_available_business" => $seats_available_business,
                "seats_available_economy" => $seats_available_economy,
                "seats_available_elite" => $seats_available_elite
            );
            array_push($flights, $flight_item);
        }

        return $flights;
    }

    public function bookFlight($data) {
        $user_id = $data['user_id'];
        $flight_id = $data['flight_id'];
        $class_id = $data['class_id'];
        $num_people = $data['num_people'];
        $weight = $data['weight'];

        if ($this->flight->bookFlight($user_id, $flight_id, $class_id, $num_people, $weight)) {
            if ($this->flight->updateSeatAvailability($flight_id, $class_id, $num_people)) {
                return array("message" => "Booking successful.");
            }
            return array("message" => "Booking successful, but failed to update seat availability.");
        }

        return array("message" => "Booking failed.");
    }
}
?>
