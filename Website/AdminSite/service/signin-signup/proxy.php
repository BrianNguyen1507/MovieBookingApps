<?php
if (!isset($_POST['url'])) {
    die('No URL provided');
}

$url = $_POST['url'];
$options = [
    'http' => [
        'header'  => "Content-Type: application/json\r\n",
        'method'  => 'POST',
        'content' => file_get_contents('php://input')
    ]
];
$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);

header('Content-Type: application/json');
echo $result;