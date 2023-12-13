import os
import cv2
import re

# Use this script to scrobble through video files quickly,
# and save desired images

def extract_number(filename):
    match = re.search(r'\d+', filename)
    return int(match.group()) if match else -1

def save_image(image, save_directory, image_file):
    cv2.imwrite(os.path.join(save_directory, image_file), image)

def main():
    image_directory = "left"
    save_directory = "accepted"

    if not os.path.exists(save_directory):
        os.makedirs(save_directory)

    image_files = sorted(os.listdir(image_directory), key=lambda x: extract_number(x))
    total_images = len(image_files)

    try:

        i = 0
        while i < total_images:
            image_file = image_files[i]
            image_path = os.path.join(image_directory, image_file)
            image = cv2.imread(image_path)
    
            cv2.imshow(f"Image {i}/{total_images}", image)
            print(f"Image {i}/{total_images}: {image_file}")
            print("Press 'a' to save this image or any other key to skip.")
    
            key = cv2.waitKey(0)
    
            if key == ord('a'):
                save_image(image, save_directory, image_file)
                print(f"accepted {image_file}")
                i += 1
            elif key == ord('q'):
                print(f"exiting")
                return
            elif key == ord('1'):
                i += 1
                print(f"advance 1 -> {i}/{total_images}")
            elif key == ord('2'):
                i += 10
                print(f"advance 10 -> {i}/{total_images}")
            elif key == ord('3'):
                i += 100
                print(f"advance 100 -> {i}/{total_images}")
            elif key == ord('4'):
                i -= 1
                print(f"reverse 1 -> {i}/{total_images}")
            elif key == ord('5'):
                i -= 10
                print(f"reverse 10 -> {i}/{total_images}")
            elif key == ord('6'):
                i -= 100
                print(f"reverse 100 -> {i}/{total_images}")
            else:
                print(f"ignored input")
    
            cv2.destroyAllWindows()

    except KeyboardInterrupt:
        print(f"Exiting")
        cv2.destroyAllWindows()

if __name__ == "__main__":
    main()

