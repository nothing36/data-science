set -e   # exit on failure

echo "📦 Creating virtual environment..."
python3 -m venv venv

echo "🔁 Activating virtual environment..."
source venv/bin/activate

echo "⬆️ Upgrading pip..."
pip install --upgrade pip

echo "🔥 Installing PyTorch with CUDA 12.6..."
pip install torch torchvision torchaudio

# if requirements exists, install them
if [ -f requirements.txt ]; then
  echo "📄 Installing additional project dependencies..."
  pip install -r requirements.txt
else
  echo "⚠️ No requirements.txt found. Skipping extra installs."
fi

# check if GPU is available
echo "🧪 Verifying PyTorch + GPU:"
python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"

rm -- "$0"   # delete file on completion