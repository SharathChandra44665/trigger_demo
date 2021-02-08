CREATE DATABASE trigger_demo_db;

USE trigger_demo_db;

CREATE TABLE users(
    username VARCHAR(255) PRIMARY KEY,
    age INT
);

INSERT INTO users(username, age) VALUES("sharathchandra",74),
    ("John Doe",33),
    ("alexa121",17);

SELECT * FROM users;

-- below is the code for triggering
DELIMITER $$

CREATE TRIGGER must_be_adult
    BEFORE INSERT ON users FOR EACH ROW
        BEGIN
            IF NEW.age < 18
            THEN 
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = "Must be an adult";
            END IF;
        END;
$$

DELIMITER ;

INSERT INTO users(username, age) VALUES("sharath2433",65);
INSERT INTO users(username, age) VALUES("susan",16);
INSERT INTO users(username, age) VALUES("Miranda",18);

-- instagram bug fix
USE insta_db;
DESC follows;



INSERT INTO follows(follower_id,followee_id) VALUES(2,2);

DELIMITER $$
CREATE TRIGGER prevent_self_follow
    BEFORE INSERT ON follows FOR EACH ROW
        BEGIN
            IF NEW.followee_id = NEW.follower_id
            THEN
                SIGNAL SQLSTATE "45000"
                SET MESSAGE_TEXT="you cannot follow yourself";
            END IF;
        END;
   
$$
DELIMITER ;


INSERT INTO follows(follower_id,followee_id) VALUES(11,11);

-- Triggering when users unfollows somebody, AFTER  CODE

CREATE TABLE unfollows(
    follower_id INT,
    followee_id INT,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id,followee_id)
);
DELIMITER $$
CREATE TRIGGER unfollow_event
    AFTER DELETE ON follows FOR EACH ROW
        BEGIN
            INSERT INTO unfollows(follower_id,followee_id) VALUES(OLD.follower_id,OLD.followee_id);
        END;
   
$$
DELIMITER ;

SELECT * FROM follows LIMIT 5;
SELECT * FROM unfollows;

DELETE FROM follows WHERE follower_id=2 AND followee_id=1;
SELECT * FROM follows LIMIT 5;
SELECT * FROM unfollows;


