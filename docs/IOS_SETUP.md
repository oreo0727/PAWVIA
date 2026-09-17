# iOS Setup

Open the project:

```bash
open ios/PetFoodIntelligence.xcodeproj
```

Local credentials:

```bash
cp ios/Config/Secrets.example.xcconfig ios/Config/Secrets.xcconfig
```

Set:

```text
PETFOOD_API_BASE_URL = http:/$()/127.0.0.1:5081
PETFOOD_API_KEY = your-development-key
```

The odd `http:/$()/` syntax prevents `.xcconfig` from treating `//` as a comment.

Run in Simulator:

1. Ensure the SSH tunnel to the PetFood API is active on the Mac at `127.0.0.1:5081`.
2. Select the `PetFoodIntelligence` scheme.
3. Select an iPhone simulator.
4. Run.

Physical iPhone:

An iPhone cannot reach the Mac's `127.0.0.1`. Use an environment-specific development base URL that the phone can reach. Do not expose the remote API insecurely just to make device testing easier.

Bundle identifier:

The placeholder is `com.example.PetFoodIntelligence` in `ios/Config/Debug.xcconfig` and `ios/Config/Release.xcconfig`.
