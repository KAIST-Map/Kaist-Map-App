import cv2
import os

def rotate_image(image_path, output_folder):
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    if image is None:
        print("Error: Unable to load image.")
        return
    
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    
    os.makedirs(output_folder, exist_ok=True)
    
    for angle in range(0, 360, 5):
        rotation_matrix = cv2.getRotationMatrix2D(center, angle, 1.0)
        rotated_image = cv2.warpAffine(image, rotation_matrix, (w, h), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(0, 0, 0, 0))
        
        output_path = os.path.join(output_folder, f"rotated_{angle}.png")
        cv2.imwrite(output_path, rotated_image)
    
    print(f"{360//5} images saved in {output_folder}")

image_path = "./my_location_direction_pin.png" 
output_folder = "my_location_direction_pin"  
rotate_image(image_path, output_folder)
