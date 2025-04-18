package my_salary.service;

import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.MessageAttributeValue;
import software.amazon.awssdk.services.sns.model.PublishRequest;
import software.amazon.awssdk.services.sns.model.PublishResponse;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;

import java.util.HashMap;
import java.util.Map;

@Service
public class SmsSenderService {
    private SnsClient snsClient;

    public SmsSenderService() {
        AwsBasicCredentials awsCreds = AwsBasicCredentials.create(
                "access key id",
                "secret access key"
        );

        this.snsClient = SnsClient.builder()
                .credentialsProvider(StaticCredentialsProvider.create(awsCreds))
                .region(Region.US_EAST_2)
                .build();

        System.out.println("AWS SNS Client initialized successfully!");
    }

    public void sendMessage(String phoneNumber, String OTP) {
        String message = "Your MySalary application verification code is: " + OTP;

        Map<String, MessageAttributeValue> messageAttributes = new HashMap<>();
        messageAttributes.put("AWS.SNS.SMS.SenderID", MessageAttributeValue.builder()
                .dataType("String")
                .stringValue("MYSALARY")
                .build());

        messageAttributes.put("AWS.SNS.SMS.SMSType", MessageAttributeValue.builder()
                .dataType("String")
                .stringValue("Transactional")
                .build());

        PublishRequest request = PublishRequest.builder()
                .message(message)
                .phoneNumber(phoneNumber)
                .messageAttributes(messageAttributes)
                .build();

        try {
            //TODO Uncomment the code to send users the verification code.
//            PublishResponse response = snsClient.publish(request);
//            System.out.println("Message sent successfully! Message ID: " + response.messageId());
        } catch (Exception e) {
            System.err.println("Failed to send SMS: " + e.getMessage());
        }
    }
}