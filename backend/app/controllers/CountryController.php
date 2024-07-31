<?php

class CountryController
{
    private $countryModel;

    public function __construct($pdo)
    {
        $this->countryModel = new Country($pdo);
    }

    public function getAllCountries()
    {
        return $this->countryModel->getAllCountries();
    }
}
?>
