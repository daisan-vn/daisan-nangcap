<?php

namespace Lib\Help;

class Mail {

    use \Lib\Singleton;

    protected $mailer;
    protected $id, $password;

    protected function __construct() {
        $this->include();
        $this->mailer = new \PHPMailer\PHPMailer\PHPMailer(true);

        $this->setID('info@daisan.vn');
        $this->setPassword('Nham@686899');

        $this->config();
    }

    protected function include() {
        require_once 'PHPMailer/src/Exception.php';
        require_once 'PHPMailer/src/PHPMailer.php';
        require_once 'PHPMailer/src/SMTP.php';
    }

    public function setID($id) {
        $this->id = $id;
    }

    public function getID() {
        return $this->id;
    }

    public function setPassword($password) {
        $this->password = $password;
    }

    public function getPassword() {
        // return \Lib\Core\Text::instance()->decrypt_string($this->password);
        return $this->password;
    }

    protected function config() {
        // Server settings
        $this->mailer->SMTPDebug = 0; // Enable verbose debug output
        $this->mailer->isSMTP(); // Set mailer to use SMTP
        $this->mailer->Host = 'smtp.gmail.com'; // Specify main and backup SMTP servers
        $this->mailer->SMTPSecure = 'ssl'; // Enable TLS encryption, `ssl` also accepted
        $this->mailer->Port = 465; // TCP port to connect to
        $this->mailer->CharSet = 'UTF-8';
        
        $this->mailer->SMTPAuth = true; // Enable SMTP authentication

        $this->mailer->Username = $this->getID(); // SMTP username
        $this->mailer->Password = $this->getPassword();
    }

    /**
    * 
    * @param array $mail_to
    * array $mail_to [array TO, array CC, array BCC]
    * @return boolean
    */
    public function send($mail_to = [], $mail_name, $mail_subject, $mail_content) {

        try {
            // Recipients
            $this->mailer->setFrom($this->getID(), $mail_name);
            if (isset($mail_to['TO']) && count($mail_to['TO'])>0){
                foreach ($mail_to['TO'] AS $item){
                    $this->mailer->addAddress($item);
                }
            }
            if (isset($mail_to['CC']) && count($mail_to['CC'])>0){
                foreach ($mail_to['CC'] AS $item){
                    $this->mailer->addCC($item);
                }
            }
            if (isset($mail_to['BCC']) && count($mail_to['BCC'])>0){
                foreach ($mail_to['BCC'] AS $item){
                    $this->mailer->addBCC($item);
                }
            }
            //$this->mailer->addReplyTo('info@example.com', 'Information');
                                                            
            // Content
            $this->mailer->isHTML(true); // Set email format to HTML
            $this->mailer->Subject = $mail_subject;
            $this->mailer->Body = $mail_content;
            $this->mailer->AltBody = 'This is the body in plain text for non-HTML mail clients';
            
            $this->mailer->send();
            return true;
        } catch (\PHPMailer\PHPMailer\Exception $e) {
            return false;
            //echo 'Message could not be sent. Mailer Error: ', $this->mailer->ErrorInfo;
        }
    }
}